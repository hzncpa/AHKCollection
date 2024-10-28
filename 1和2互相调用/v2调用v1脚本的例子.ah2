;一个v2调用v1的例子,v1返回的内容存入临时文件给v2读取
;v1部分
v1("dmoney")
v1(myfunc,path:=A_Temp "\ahk.txt"){
if (A_Args[1] && myfunc){
	if islabel(myfunc)
		gosub % myfunc
	else
		data:=%myfunc%(A_Args[1])
	filedelete % A_Temp "\ahk.txt"
	fileappend % data,% a_path
}
	exitapp
	}


;v2部分
 ;v2和v2通过临时文件简单互相调用并传递一些数据的例子,避免使用剪切板防止出问题
 money := InputBox().value
 msgbox runAhk("D:\SoftDir\ahk\Lib\dmoney.ahk " money)


runAhk(a_path,a_interpreter:="v1_32",a_ahkdir:="C:\Program Files\AutoHotkey"){
	SetWorkingDir a_ahkdir
	SplitPath a_path, &name, &dir, &ext, &name_no_ext, &drive
	a_interpreter:=(instr(name,"v2_")?"v2_32":instr(name,"v1_")?"v1_32":a_interpreter)
	switch a_interpreter
	{
	case "v1_32":
		run a_ahkdir "\autohotkeyU32.exe " a_path
	case "v1_64":
		run a_ahkdir "\autohotkeyU64.exe " a_path
	case "v2_32":
		run a_ahkdir "\v2\autohotkey32.exe " a_path
	case "v2_64":
		run a_ahkdir "\v2\autohotkey64.exe " a_path
	case "ux":
		run a_ahkdir "\UX\AutoHotkeyUX.exe " a_path 
	default:
		run a_interpreter " " a_path
	}
	sleep 200
	return fileread(A_Temp "\ahk.txt")
}


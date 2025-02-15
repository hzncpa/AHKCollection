#Requires AutoHotkey >=1.1.36 <v1.2
#SingleInstance Force
#NoTrayIcon
;**************************************************************************************
; Party 2023.10.28
; AutoHotKey 1.1.36
; 功能：使用7z实现智能解压
; 1. 如果压缩包根目录只有一个对象，直接解压
;	 --此情况下，如果当前目录已经存在同名对象，使用7z的 -aou 参数处理。需要改为其它方式自行修改
;		-aoa Overwrite All existing files without prompt. 
;		-aos Skip extracting of existing files. 
;		-aou aUto rename extracting file (for example, name.txt will be renamed to name_1.txt). 
;		-aot auto rename existing file (for example, name.txt will be renamed to name_1.txt). 
;    --参数-aou和-aot不会给文件夹重命名，而是给文件重命名。即：
;		- 两个压缩包内的根目录都有一个同名的文件夹，它们会被解压到同一个文件夹内
;		- 原路径已经存在与压缩包内根目录同名的文件夹，就会被解压进去，而不是新建一个+1的文件夹
; 2. 如果压缩包根目录有多个对象，解压到同名文件夹内
;  	 --此情况下，如果当前目录存在同名文件夹，创建序号+1的文件夹，并解压到里面
;    --与-aou和-aot不同，这里是直接创建文件夹
; 3. 暂时只支持原路径解压，解压到对侧没做
; 4. 已知bug，分支视图中，压缩包内的根目录只有一个文件夹，并且与所处文件夹同名时，会解散解压
;
; 接收参数：
;	文件列表的文件，每行一个文件。使用 TC 的 %L 参数
;
; 使用说明：
; 1. 修改7z.exe和7zG.exe的路径
; 2. usercmd.ini添加命令：
; [em_SmartExtract]
; menu=智能解压
; cmd=改为自己SmartExtract.ahk的路径 
; param=%L

;**************************************************************************************

;获取TC的%L参数
zipFileList := A_Args[1]

;逐行读取 zipFileList 然后调用 extract 解压
Loop
{
    FileReadLine, line, %zipFileList%, %A_Index%
    if ErrorLevel
        break
    Extract(line)
}

;解压指定压缩包
Extract(file){
	7z := "D:\Program Files\7-Zip\7z.exe"
	7zG := "D:\Program Files\7-Zip\7zG.exe"
	
	;msgbox % file 
	if NOT FileExist(file){
		MsgBox, 文件不存在
		Return
	}
	
	; 如果是文件夹，跳过
	FileGetAttrib, Attributes, %file%
	if InStr(Attributes, "D")
	{
		MsgBox,16,提示 ,所选对象是个文件夹，自动跳过. ,1
		Return
	}
	
	; 如果不是压缩文件，跳过
	testCmd := "cmd /c " """""" 7z """" " t """ file """ | find /C ""Can't"""""	
	testResult := intparse(Trim(StdoutToVar_CreateProcess(testCmd)))
	if(testResult>0){
		MsgBox,16,提示 ,所选对象不是压缩文件，自动跳过. ,1
		Return
	}
	
	;获取所有file数量
	;sumFileCmd := "cmd /c " """""" 7z """" " l -slt " file " | find /C ""Path"""""
	;参数的路径也可能有空格
	sumFileCmd := "cmd /c " """""" 7z """" " l -slt """ file """ | find /C ""Path"""""
	;msgbox % sumFileCmd
	sumFile := intparse(Trim(StdoutToVar_CreateProcess(sumFileCmd)))
	;msgbox % sumFile

	;获取路径中包含 \ 的file数量
	sumFolderCmd := "cmd /c " """""" 7z """" " l -slt """ file """ | find ""Path"" | find /C ""\"""""
	sumFolder := intparse(trim(StdoutToVar_CreateProcess(sumFolderCmd)))
	;msgbox % sumFolder

	;两者相减，就是当前目录下对象的数量
	sumRootFile := (sumFile - sumFolder)
	;msgbox % sumRootFile
	
	SplitPath, file, name, dir, ext, name_no_ext, drive
	
	if (sumRootFile=1){	
	;直接解压
	;param=x -spe %P%N -o"%P%O\"
		cmd :="""" 7zG """ x -spe """ file """ -aou -o""" dir """ "
		run, %cmd%
	} else {
	;解压到和压缩包同名的目录内
		;获取压缩包名称和路径，作为解压参数
				
		filePath := dir "\" name_no_ext
		;转换为不重名的唯一路径
		filePath := UniquePathName(filePath)
		;msgbox % filePath
	
		cmd :="""" 7zG """ x -spe """ file """ -aou -o""" filePath """ "
		run, %cmd%
	}
}

;转换传入路径为不重名路径，自动加1，格式为 name_1、name_2
UniquePathName(path) {
    SplitPath, path, name, dir, ext, name_no_ext, drive
    newPath := ""
    index := 1
    while (FileExist(path)) {
		if( ext = ""){
			newPath := name_no_ext "_" index
		}else{		
			newPath := name_no_ext "_" index "." ext		
		}		
        path := dir "\" newPath		
        index++
    }
    return path
}

;获取cmd命令执行的结果
StdoutToVar_CreateProcess(sCmd, sEncoding:="CP0", sDir:="", ByRef nExitCode:=0) {
    DllCall( "CreatePipe",           PtrP,hStdOutRd, PtrP,hStdOutWr, Ptr,0, UInt,0 )
    DllCall( "SetHandleInformation", Ptr,hStdOutWr, UInt,1, UInt,1                 )

            VarSetCapacity( pi, (A_PtrSize == 4) ? 16 : 24,  0 )
    siSz := VarSetCapacity( si, (A_PtrSize == 4) ? 68 : 104, 0 )
    NumPut( siSz,      si,  0,                          "UInt" )
    NumPut( 0x100,     si,  (A_PtrSize == 4) ? 44 : 60, "UInt" )
    NumPut( hStdOutWr, si,  (A_PtrSize == 4) ? 60 : 88, "Ptr"  )
    NumPut( hStdOutWr, si,  (A_PtrSize == 4) ? 64 : 96, "Ptr"  )

    If ( !DllCall( "CreateProcess", Ptr,0, Ptr,&sCmd, Ptr,0, Ptr,0, Int,True, UInt,0x08000000
                                  , Ptr,0, Ptr,sDir?&sDir:0, Ptr,&si, Ptr,&pi ) )
        Return ""
      , DllCall( "CloseHandle", Ptr,hStdOutWr )
      , DllCall( "CloseHandle", Ptr,hStdOutRd )

    DllCall( "CloseHandle", Ptr,hStdOutWr ) ; The write pipe must be closed before reading the stdout.
    While ( 1 )
    { ; Before reading, we check if the pipe has been written to, so we avoid freezings.
        If ( !DllCall( "PeekNamedPipe", Ptr,hStdOutRd, Ptr,0, UInt,0, Ptr,0, UIntP,nTot, Ptr,0 ) )
            Break
        If ( !nTot )
        { ; If the pipe buffer is empty, sleep and continue checking.
            Sleep, 100
            Continue
        } ; Pipe buffer is not empty, so we can read it.
        VarSetCapacity(sTemp, nTot+1)
        DllCall( "ReadFile", Ptr,hStdOutRd, Ptr,&sTemp, UInt,nTot, PtrP,nSize, Ptr,0 )
        sOutput .= StrGet(&sTemp, nSize, sEncoding)
    }
    
    ; * SKAN has managed the exit code through SetLastError.
    DllCall( "GetExitCodeProcess", Ptr,NumGet(pi,0), UIntP,nExitCode )
    DllCall( "CloseHandle",        Ptr,NumGet(pi,0)                  )
    DllCall( "CloseHandle",        Ptr,NumGet(pi,A_PtrSize)          )
    DllCall( "CloseHandle",        Ptr,hStdOutRd                     )
    Return sOutput
}

;把字符串转为数值，沙雕AHK V1，没有字符串转成数值的函数
intparse(str) {

	str = %str% ; removes formatting

	Loop, Parse, str ; parse through each character

		If A_LoopField in 0,1,2,3,4,5,6,7,8,9,.,+,-

			int = %int%%A_LoopField% ; build integer

	Return, int + 0 ; returns real number
}

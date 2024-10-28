#SingleInstance Force ;{{{管理员启动
{
	param := %A_Index% ; Fetch the contents of the variable whose name is contained in A_Index.
	params .= A_Space . param
}
ShellExecute := A_IsUnicode ? "shell32\ShellExecute":"shell32\ShellExecuteA"
if not A_IsAdmin
{
	if A_IsCompiled
		DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_ScriptFullPath, str, params , str, A_WorkingDir, int, 1)
	else
		DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_AhkPath, str, """" . A_ScriptFullPath . """" . A_Space . params, str, A_WorkingDir, int, 1)
	ExitApp
}

#SingleInstance Force
#MaxMem 640
#Persistent
SetBatchLines -1
DetectHiddenWindows On
SetWinDelay -1
SetControlDelay -1
SetWorkingDir %A_ScriptDir%
 ;}}}
xl:=ComObjActive("excel.Application")
MsgBox,% xl.Selection.Value

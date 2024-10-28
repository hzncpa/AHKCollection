#SingleInstance Force ;{{{

loop, %0%
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
 ;}}}
GroupAdd,excel,ahk_class XLMAIN
GroupAdd,excel,ahk_exe wps.exe
GroupAdd,excel,ahk_class OpusApp

#IfWinActive ahk_group excel
F1::
xl:=ComObjActive("excel.Application")
xl.Selection.Offset(0, -1).Value:=14
xl.Selection.Offset(0, 1).Value:=42
xl.Selection.Value:=xl.Selection.Value-42
Return

F2::
xl:=ComObjActive("excel.Application")
xl.Selection.Offset(0, -1).Value:=7
xl.Selection.Offset(0, 1).Value:=21
xl.Selection.Value:=xl.Selection.Value-21
Return

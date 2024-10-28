#SingleInstance, Force ; {{{
DetectHiddenWindows, Off  ;
#MaxMem 2048
SetBatchLines, -1
Process, Priority,, High
#MaxThreadsPerHotkey 100
#MaxHotkeysPerInterval 400
SendMode Input
SetBatchLines, -1
SetKeyDelay, -1
SetMouseDelay, -1
CoordMode, ToolTip, Screen

loop, %0%
{
	param := %A_Index% ; Fetch the contents of the variable whose name is contained in A_Index.
	params .= A_Space . param
}
ShellExecute := A_IsUnicode ? "shell32\ShellExecute":"shell32\ShellExecuteA"
if not A_IsAdmin
{
	if A_IsCompiled
		DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_ScriptFullPath, str, params , str, A_WorkingDir, int)
	else
		DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_AhkPath, str, """" . A_ScriptFullPath . """" . A_Space . params, str, A_WorkingDir, int)
	ExitApp
}

;}}}
;传入文件夹参数,清理这个文件夹内各种广告推广文件
;A_Args[1] %P
path:=A_Args[1]


;3dm
dirdelete %path%\3DM\
dirdelete %path%\3dm\
FileDelete %path%\启动游戏.exe
FileDelete %path%\3dmConfig.ini

;各类url包括果壳啥的
FileDelete %path%\*.url

;游侠
dirdelete %path%\ali213\
FileDelete %path%\开始游戏.exe
FileDelete %path%\ALI213.ini
FileDelete %path%\ali213.bin

;果壳
FileDelete %path%\关注微信 - 更多福利.png



ExitApp

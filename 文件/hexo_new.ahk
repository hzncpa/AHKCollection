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
		DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_ScriptFullPath, str, params , str, A_WorkingDir, int, 1)
	else
		DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_AhkPath, str, """" . A_ScriptFullPath . """" . A_Space . params, str, A_WorkingDir, int, 1)
	ExitApp
}

;}}}
FormatTime, DateTimeStr, % A_Now, yyyy-MM-dd HH:mm:ss
despath=%USERPROFILE%\blog\source\_posts\
open=%COMMANDER_PATH%\tools\vim\gvim.exe -p --remote-tab-silent 
InputBox,name,name,name,,,,,,,,随笔
if (name=="")
	ExitApp
text=
(
---
title: %name%
date: %DateTimeStr%
tags:
- 
categories:
- 
cover:
---

)
new:=despath name ".md"
FileAppend,%text%,%new%,UTF-8
sleep 200
run %open% %new%
ExitApp

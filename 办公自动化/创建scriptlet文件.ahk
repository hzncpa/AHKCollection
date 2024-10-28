;配置 {{{
#SingleInstance, Force 
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


;脚本自检测，如果不是管理员就自动以管理员权限运行自身
if !(A_IsAdmin || InStr(DllCall("GetCommandLine", "str"), ".exe"" /r"))
    RunWait % "*RunAs " (s:=A_IsCompiled ? "" : A_AhkPath " /r ") """" A_ScriptFullPath """" (s ? "" : " /r")
;}}}
F1::
inputbox,a
FileAppend,
(
/**

*/
),D:\OneDrive\SoftDir\SciTE\user\Scriptlets\%a%.scriptlet
return

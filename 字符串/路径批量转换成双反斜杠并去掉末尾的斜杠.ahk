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

#persistent
settimer,re_index,1000

re_index(){
FileGetTime,last_user, %A_ScriptFullPath%, M
if ( A_now-last_user<2 )
		reload
}
;}}}
a=
(
B:\百度网盘\凭证保存\扫描文件留存\房产证2\
B:\百度网盘\凭证保存\扫描文件留存\执业许可\
)
clipboard:=""
Loop, parse, a, `n, `r  ; 在 `r 之前指定 `n, 这样可以同时支持对 Windows 和 Unix 文件的解析.
{
	if( instr(fileexist(A_LoopField),"D") ){
			SplitPath,A_LoopField, name, dir, ext, name_no_ext, drive
			clipboard.=dir "`r`n"
	}
		else
			clipboard.=A_LoopField "`r`n"
}
	clipboard:=strreplace(clipboard,"\","\\")

msgbox % clipboard

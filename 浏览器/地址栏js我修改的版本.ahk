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
;v1()


;---------------------------------
;  AHK利用地址栏实现网页自动化  By FeiYue
;
;  简单的GUI窗口用于测试，实际使用RunJs()函数
;---------------------------------
js=  ;-- 这个JS代码实现浏览器跳转到下一页
(
alert(1);
)
#NoEnv
Gui, +AlwaysOnTop +Resize
Gui, Font, s14 cGreen
Gui, Color, DDEEFF
Gui, Margin, 15, 15
Gui, Add, Edit, vmyedit w500 h300 -Wrap HScroll, %js%
Gui, Add, Button, vmybutton wp gRun Default, 运行JS代码
GuiControlGet, pos, Pos, mybutton
GuiControl, Focus, mybutton
Gui, Show,, 网页自动化测试平台
OnMessage(0x201, "LButton_Down")
LButton_Down()
{
    if (A_GuiControl="")
        SendMessage, 0xA1, 2
}
Menu, Tray, Click, 1
Menu, Tray, Add
Menu, Tray, Add, 打开测试平台
Menu, Tray, Default, 打开测试平台
打开测试平台:
Gui, Show
return
GuiSize:
if (ErrorLevel=1)
    return
GuiControl, Move, myedit
    , % "W" (A_GuiWidth-15*2) " H" (A_GuiHeight-15*3-posH)
GuiControl, Move, mybutton
    , % "W" (A_GuiWidth-15*2) " Y" (A_GuiHeight-15-posH)
return
Run:
Gui, Hide
Gui, Show, NA
GuiControlGet, js,, myedit
RunJs(js, "ahk_exe vivaldi.exe")
return
;-- 在脚本中调用 RunJs() 即可实现网页自动化
RunJs(js, window:="ahk_exe vivaldi.exe",shortcut:="!d") {
winactivate %window%
winwait %window%,,3
if( winactive(window) ){
	send %shortcut%
	sleep 100
	sendinput {text}javascript:%js%
	sleep 100
	send {enter}
	;sendinput % shortcut "{text}javascript:" js "`n`"
}
}

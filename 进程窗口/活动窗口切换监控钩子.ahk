; 窗口切换钩子调用
DllCall("RegisterShellHookWindow", "Ptr", A_ScriptHwnd), OnMessage(DllCall("RegisterWindowMessage", "Str", "ShellHook"), "ShellEvent")


;活动窗口切换监控【异步触发】
	/*    wParam参数：
		;1 顶级窗体被创建 	;2 顶级窗体即将被关闭 	;54 退出全屏	;32772 窗口切换
		;3 SHELL 的主窗体将被激活 	;4 顶级窗体被激活 	;&H8000& 掩码 	;53 全屏
		;5 顶级窗体被最大化或最小化 	;6 Windows 任务栏被刷新，也可以理解成标题变更
		;7 任务列表的内容被选中 	;8 中英文切换或输入法切换 	;13 wParam=被替换的顶级窗口的hWnd 
		;9 显示系统菜单 	;10 顶级窗体被强制关闭 	;14 wParam=替换顶级窗口的窗口hWnd
		;12 没有被程序处理的APPCOMMAND。见WM_APPCOMMAND
	*/
ShellEvent(wParam, lParam) {
	Static a=0
	ToolTip % "切换窗口是触发 " a+=1
 }

;这个例子是检测到记事本激活就会弹窗提示
;ShellEvent(wParam, lParam) {
;	WinGetClass, Class, ahk_id %lParam%
;	If (Class = "Notepad")
;        MsgBox 检测到记事本窗口激活
;}
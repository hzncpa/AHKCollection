; 作用域为Gui生成框体内，移动鼠标触发
WM_SETCURSOR() {
    Static init:=OnMessage(0x20, "WM_SETCURSOR")
	Tooltip 如果鼠标引起光标在某个窗口中移动且鼠标输入没有被捕获时，就发消息给某个窗口
}

; 作用域为为新建窗口时【类似：WM_NCPAINT := 0x85】
WM_NCCALCSIZE() {
    Static init:=OnMessage(0x83, "WM_NCCALCSIZE")
	Tooltip 当某个窗口的客户区域必须被核算时发送此消息
}

; 作用域为Gui生成框体内，移动鼠标触发【移动到控件按钮上除外】
WM_NCHITTEST() {
    Static init:=OnMessage(0x84, "WM_NCHITTEST")
	Tooltip 移动鼠标，按住或释放鼠标时发生
}

; 作用域为Gui生成框体激活和非激活状态时触发
WM_NCACTIVATE() {
    Static init:=OnMessage(0x86, "WM_NCACTIVATE")
	Tooltip 此消息发送给某个窗口 仅当它的非客户区需要被改变来显示是激活还是非激活状态
}

; 作用域当鼠标移动到Gui生成框体的边缘时触发
WM_NCMOUSEMOVE() {
    Static init:=OnMessage(0xA0, "WM_NCMOUSEMOVE")
	Tooltip 当光标在一个窗口的非客户区内移动时发送此消息给这个窗口 非客户区为：窗体的标题栏及窗的边框体
}

; 作用域Gui生成框体内键盘按下一个键时触发【WM_KEYUP := 0x101 ; 释放一个键】
WM_KEYDOWN() {
    Static init:=OnMessage(0x100, "WM_KEYDOWN")
	Tooltip 键盘按下一个键
}

; 作用域为Gui生成框体点击控件时触发
WM_COMMAND() {
    Static init:=OnMessage(0x111, "WM_COMMAND")
	Tooltip 当用户选择一条菜单命令项或当某个控件发送一条消息给它的父窗口，或某快捷键被翻译时,本消息被发送
}

; 作用域为Gui生成框体点击标题栏，最大化最小化窗口，拖动大小时触发
WM_SYSCOMMAND() {
    Static init:=OnMessage(0x112, "WM_SYSCOMMAND")
	Tooltip 当用户选择窗口菜单的一条命令或当用户选择最大化或最小化时那个窗口会收到此消息
}

; 作用域为Gui生成框体按下鼠标左键触发
WM_LBUTTONDOWN() {
    Static init:=OnMessage(0x201, "WM_LBUTTONDOWN")
	Tooltip 按下鼠标左键
}

; 作用域为主要是在Gui控件按下鼠标按键时触发
WM_PARENTNOTIFY() {
    Static init:=OnMessage(0x210, "WM_PARENTNOTIFY")
	Tooltip 当MDI子窗口被创建或被销毁，或用户按了一下鼠标键而光标在子窗口上时发送此消息给它的父窗口
}
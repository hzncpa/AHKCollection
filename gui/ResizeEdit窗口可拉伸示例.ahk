
MsgBox % SetResizeEditGui("测试框",,,300,3)
ExitApp

SetResizeEditGui(Title:="InputBox",TipText:="", IsNumber=0, Width:=250,Row=2,NoOwner=0,Owner:="",GHWND:=0){
	static
	ButtonOK:=ButtonCancel:= false,IsNumber:=IsNumber=1?" Number ":"",O:=NoOwner?" +Owner -SysMenu":""
	,flag:=0,wpos:=0,hpos:=0,IsLightTheme:=A_HOUR>5&&A_HOUR<19?1:0
	SysGet, CXVSCROLL, 2
	SysGet, SM_CYSIZE, 31
	SysGet,SM_CYSIZEFRAME ,33
	Gui, InputBox:Destroy
	If Owner
		Gui, InputBox:+Owner%Owner%
	Gui, InputBox: %O%  +Resize -MaximizeBox +LastFound -MinimizeBox hWndsInputBox
	Gui,InputBox:Color,% !IsLightTheme?"333333":"Default",% !IsLightTheme?"333333":"Default"
	Gui, InputBox:Font,% "s10 norm " (!IsLightTheme?"cCDCDCD":"Default"), % GetDefaultFontName()
	Gui, InputBox: add, Edit,x15 y15 r%Row%  w%Width% %IsNumber% vInputBox hwndIBox WantTab +Wrap Lowercase,% Row>1?TipText:""
	Gui, InputBox: add, Button, w60 gInputBoxOK vInputBoxOK HWNDBTNT8, &确定
	GuiControlGet, ibox, Pos , InputBoxOK
	xpos:=Width-45
	Gui, InputBox: add, Button, w60 x%xpos% yp gInputBoxCancel HWNDBTNT9, &取消
	If (Row=1)
		EM_SetCueBanner(IBox, TipText)
	Gui, InputBox:Font,% "s9 norm " (!IsLightTheme?"cCDCDCD":"Default"), % GetDefaultFontName()
	Gui, InputBox:Add,StatusBar,% !IsLightTheme?"BackgroundCDCDCD -Theme ":"BackgroundDefault -Theme ",>>窗口边缘可以调节窗口大小。
	Gui, InputBox: Show,AutoSize, % Title
	if !NoOwner
		Gui, InputBox: -AlwaysOnTop
	SendMessage, 0xB1, 0, -1, Edit1, A
	ControlFocus , Edit1, A
	while !(ButtonOK||ButtonCancel){
		if (!WinExist("ahk_id " GHWND)&&GHWND){
			Gui, InputBox:Destroy
		}Else{
			continue
		}
	}
	if (ButtonCancel) {
		return
	}
	Gui, InputBox: Submit, NoHide
	Gui, InputBox:Destroy
	flag:=0
	return InputBox

	InputBoxOK:
		ButtonOK:= true
	return

	InputBoxGuiSize:
		If !flag {
			flag:=1
			Gui, InputBox:+MinSize%A_GuiWidth%x%A_GuiHeight%
		}else{
			ControlGetPos , X_button, Y_button, W_button, H_button, Button1
			ControlGetPos , X_Edit, Y_Edit, Width, Height, Edit1
			GuiControl, InputBox:move, Edit1 , % "w" A_GuiWidth-(X_Edit-8)-SM_CYSIZEFRAME*(A_ScreenDPI/96) " h" A_GuiHeight-(Y_Edit-SM_CYSIZE*(A_ScreenDPI/96))*2-H_button
			GuiControl, InputBox:move, Button1 , % "y" A_GuiHeight-(Y_Edit-SM_CYSIZE*(A_ScreenDPI/96))-H_button
			GuiControl, InputBox:move, Button2 , % "y" A_GuiHeight-(Y_Edit-SM_CYSIZE*(A_ScreenDPI/96))-H_button "x" A_GuiWidth-(X_Edit-8+W_button)//(A_ScreenDPI/96)
			GuiControl,InputBox:,Button2,取消
			GuiControl,InputBox:,Button1,确定
		}
		wpos:= A_GuiWidth ,hpos:= A_GuiHeight,SB_SetParts(A_GuiWidth*0.75,A_GuiWidth*0.25)
	return

	InputBoxGuiClose:
	InputBoxCancel:
		ButtonCancel:= true,flag:=0
		Gui, InputBox:Destroy
	return
}

EM_SetCueBanner(hWnd, Cue)
{
	static EM_SETCUEBANNER := 0x1501
	return DllCall("User32.dll\SendMessage", "Ptr", hWnd, "UInt", EM_SETCUEBANNER, "Ptr", True, "WStr", Cue)
}

GetDefaultFontName(){
	NumPut(VarSetCapacity(info, A_IsUnicode ? 504 : 344, 0), info, 0, "UInt")
	DllCall("SystemParametersInfo", "UInt", 0x29, "UInt", 0, "Ptr", &info, "UInt", 0)
	return StrGet(&info + 52)
}
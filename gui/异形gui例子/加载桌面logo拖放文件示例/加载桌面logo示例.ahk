#Persistent
#Include gdip_all.ahk
OnMessage(0x201,"WM_LBUTTONDOWN")
;OnMessage(0x233,"WM_DROPFILES")

ImagePath:=A_ScriptDir "\bagel.png"
logosize:=50   ;缩放比例
xpos:=200,ypos:=100
load_logo_box(ImagePath,logosize,xpos,ypos)
;==========================================
IsModifyLogoSize:= Func("IsExistLogo")
Hotkey,if, % IsModifyLogoSize
Hotkey $WheelDown, ModifyLogoDownSize
Hotkey $WheelUp, ModifyLogoUpSize
;==========================================
SetTimer,GetLogoClientPos,On
Return
;==========================================

;拖拽事件
logoGuiDropFiles:
	if A_EventInfo&&A_GuiEvent {
		AllFileList:=A_GuiEvent
		Gosub CreateLogoMenu
	}
Return

HandlingFilelabels:
	Loop, Parse, AllFileList, `n
	{
		MsgBox % A_LoopField
	}
Return

;创建菜单
CreateLogoMenu:
	if MenuGetHandle("logo")
		Menu, logo, DeleteAll
	Menu, logo, UseErrorLevel
	Menu, logo,Add, 菜单项1,MenuItemLabel
	Menu, logo,Add
	Menu, logo,Add, 菜单项2,MenuItemLabel
	Menu, logo,Add
	Menu, logo,Add, 菜单项3,MenuItemLabel
	Menu, logo,Add
	Menu, logo,Add, 菜单项4,MenuItemLabel
	Menu, logo,Show
Return

MenuItemLabel:
	Switch A_ThisMenuItem
	{
		Case "菜单项1":
			Gosub HandlingFilelabels
		Case "菜单项2":
			Gosub HandlingFilelabels
		Case "菜单项3":
			Gosub HandlingFilelabels
		Case "菜单项4":
			Gosub HandlingFilelabels
	}
Return

GetLogoClientPos:
	if WinExist("ahk_id " hlogo){
		VarSetCapacity( size, 16, 0 )
		DllCall( "GetClientRect", "Ptr", hlogo, "Ptr", &size )
		DllCall( "ClientToScreen", "Ptr", hlogo, "Ptr", &size )
		xpos := NumGet( size, 0, "Int"), ypos := NumGet( size, 4, "Int")
	}
Return

ModifyLogoDownSize:
	logosize--
	load_logo_box(ImagePath,logosize,xpos,ypos)
Return

ModifyLogoUpSize:
	logosize++
	load_logo_box(ImagePath,logosize,xpos,ypos)
Return

IsExistLogo(){
	Global hlogo
	CoordMode,Mouse,Screen
	MouseGetPos,,,MID

	Return (MID&&MID=hlogo?True:False)
}

load_logo_box(ImagePath,logosize:=50,xpos:=100,ypos:=100,logoAlpha:=255){
	Global hlogo
	pToken := Gdip_Startup()
	pBitmap := Gdip_CreateBitmapFromFile(ImagePath)
	if !pBitmap
		Return
	Gui, logo: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs +Hwndhlogo
	Gui, logo: Show, NA
	Ratio:=(logo_Width:=Gdip_GetImageWidth(pBitmap))/(logo_Height:=Gdip_GetImageHeight(pBitmap))
	, DisplayWidth:=Round(logo_Width*logosize/100), DisplayHeight:=DisplayWidth//Ratio
	pBitmap:=Gdip_ResizeBitmap(pBitmap, DisplayWidth, DisplayHeight, 0)
	hbm := CreateDIBSection(DisplayWidth, DisplayHeight),hdc := CreateCompatibleDC()
	obm := SelectObject(hdc, hbm),G := Gdip_GraphicsFromHDC(hdc)
	Gdip_SetInterpolationMode(G, 7),Gdip_DrawImageFast(G, pBitmap, 0, 0)
	UpdateLayeredWindow(hlogo, hdc,xpos , ypos, DisplayWidth, DisplayHeight,logoAlpha>0&&logoAlpha<=255?logoAlpha:255)
	SelectObject(hdc, obh), DeleteObject(hbm), DeleteDC(hdc),Gdip_DeleteGraphics(G),Gdip_DisposeImage(pBitmap)
	OnMessage(0x20, Func("WM_SETCURSOR").Bind(hlogo))

}

logoGuiContextMenu(GuiHwnd, CtrlHwnd, EventInfo, IsRightClick, X, Y){
	if (IsRightClick){
		Gosub CreateLogoMenu
	}
}


WM_LBUTTONDOWN(wParam, lParam, uMsg, hWnd){
	if (A_Gui="logo"&&HWND)
		DllCall("user32.dll\PostMessage", "ptr", hWnd, "uint", 0x00A1, "ptr", 2, "ptr", 0)
}

WM_SETCURSOR(hPic, wp) {
	static hCursor, flags := (LR_DEFAULTSIZE := 0x40) | (LR_SHARED := 0x8000)
		, params := [ "Ptr", 0, "UInt", OCR_HAND := 32649
			, "UInt", IMAGE_CURSOR := 2
			, "Int", 0, "Int", 0, "UInt", flags, "Ptr" ]
	(!hCursor && hCursor := DllCall("LoadImage", params*))
	if (wp = hPic)
		Return DllCall("SetCursor", "Ptr", hCursor)
}
DetectHiddenWindows, Off
;SetWorkingDir, ../

IniRead, dismisslist, setting.ini, dismiss
WindArray := {}
SysGet, OutputVar, MonitorCount
WinName =选择不希望显示在曹操快切的窗口
WinGet, OpenWindow, List 


	If !WinExist(WinName)
		 {
			Gui,+AlwaysOnTop
			Gui, Font, s11, Arial
			Gui, Add, DropDownList, gShowToolTip x7 y9 w260 vWindowMove,Pick a Window||
			Gui, Add, Button, x282 y8 w50 h28 gPosChoice, 添加
		 }
	Else
		 {
			Gui, Destroy
			Gui,+AlwaysOnTop
			Gui, Font, s11, Arial	
			Gui, Add, DropDownList, gShowToolTip x7 y9 w260 vWindowMove,Pick a Window||
			Gui, Add, Button, x282 y8 w50 h28 gPosChoice, 添加
		 }
	
	Loop, %OpenWindow% 
	{ 
		
		id := OpenWindow%A_Index%
		WinGetTitle Title, ahk_id %id%
		WinGet, style, style, ahk_id %id%
		WinGet, ClsID, ID, ahk_id %id%
		Loop, parse, dismisslist, `n, `r
		{
			If (title = A_LoopField)
		{
			sumdiss:=sumdiss+1
			continue, 2
		}
		}
		If (title = "")
			continue
		WinGetClass class, ahk_id %id%	
		If (class = "ApplicationFrameWindow") 
		{
			WinGetText, text, ahk_id %id%		
			If (text = "")
			{
				WinGet, style, style, ahk_id %id%
				If !(style = "0xB4CF0000")	 ; the window isn't minimized
					continue
			}
		}

		GuiControl,,WindowMove, %Title%
		WindArray.Insert(Title, ClsID)
	} 

Gui, Show,  h45 w345, %WinName%
hwnd:=WinExist(WinName)
Return

ShowToolTip:
Gui,Submit,NoHide
;remove any previous tooltip
GoSub RemoveToolTip

if (InStr(WindowMove, "Pick a Window", true) = 0 and WindowMove!="")
{

	ControlGetPos,x,y,w,h,ComboBox1,ahk_id %hwnd%

	ToolTip %WindowMove%,x,y+h,10

	SetTimer,RemoveToolTip,-3000
}
Return


PosChoice:
Gui, Submit, NoHide
if (InStr(WindowMove, "Pick a Window", true) = 0 and WindowMove!="")
{
	;return Associative array value
	IDValue:= WindArray[WindowMove]
		WinGetTitle theTitle, ahk_id %IDValue%
	FileAppend ,%thetitle%`n, setting.ini
		reload ; Recall it again to refresh status
	GoSub RemoveToolTip
}
Return

RemoveToolTip:
	ToolTip,,,,10
Return

GuiClose:
run cc.ahk
ExitApp

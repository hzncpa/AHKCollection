DetectHiddenWindows, Off
;SetWorkingDir, ../
SetTitleMatchMode, 3

IniRead, dismisslist, setting.ini, dismiss
WindArray := {}
SysGet, OutputVar, MonitorCount
WinName =添加固定搭配
WinGet, OpenWindow, List 


	If !WinExist(WinName)
		 {
			;Gui,+AlwaysOnTop
			Gui, Font, s11, Arial
			Gui, Add, DropDownList, gShowToolTip x7 y9 w260 vWindowMove,Pick a Window||
			Gui, Add, Button, x282 y8 w50 h28 gPosChoice, 添加
		 }
	Else
		 {
			Gui, Destroy
			;Gui,+AlwaysOnTop
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
		Title := StrReplace(Title, "|" , "甴")
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
	IDValue:= WindArray[WindowMove]
	WinGetTitle theTitle, ahk_id %IDValue%
	WinGet, exename, ProcessName , ahk_id %IDValue%
	Gosub showinputbox
		reload ; Recall it again to refresh status
	GoSub RemoveToolTip
}
Return

RemoveToolTip:
	ToolTip,,,,10
Return

showinputbox:
InputBox, thenum , 你想将%exename%绑定到哪个按键？, 请输入单个数字或字母，然后点确定, , , , , , Locale, , 
IniWrite, % exename, setting.ini, setting, % thenum
return

GuiClose:
run cc.ahk
ExitApp

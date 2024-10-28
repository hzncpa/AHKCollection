;v1 or v2 ;{{{
#Requires AutoHotkey <=2.0 ;v1
#SingleInstance Force  v1
;#Requires AutoHotkey >=2.0 ;v2
re_index(){
FileGetTime last_user, %A_ScriptFullPath%, M ;v1
;last_user:=filegettime(A_scriptfullpath) ;v2
if ( A_now-last_user<1.5 )
		reload
}
SetKeyDelay 0
SetMouseDelay 0
settimer re_index,1000
 ;}}}
onclipboardchange("changeEdit")

changeEdit(){
	if (instr(clipboard,"#") && strlen(clipboard)==7)
	guicontrol RGB:,color_hex,% clipboard
	gosub changcolor
}

Cando_颜色查看:
    Color_Hex := StrReplace(Color_Hex, "#", "")
    Color_RGB := Hex2RGB(Color_Hex)
    Color_RGB := "RGB(" Color_RGB ")"
    Gui,RGB: Default
    Gui,RGB:Destroy
    Gui,RGB:+Lastfound +AlwaysOnTop
    Gui,RGB:add, text, x7, 输入格式举例：#FF0000 FF0000
    Gui,RGB:add, text, x7, 颜色代码(Hex):
    Gui,RGB:Add, edit, x+10 w120 vcolor_hex, %Color_Hex%
    Gui,RGB:add, button, x+120 default gchangcolor, Ok
    Gui,RGB:add, text, x7, 颜色代码(RGB):
    Gui,RGB:Add, edit, x+10 readonly w120 vColor_RGB, %Color_RGB%
    Gui,RGB:add, text, x7, 颜色:
    Gui,RGB:Add, Progress, x+10 c%Color_Hex% w170 h170 vprobar, 100
    Gui,RGB:Show, w230 h230, 颜色查看
Return


RGBGuiescape:
RGBGuiClose:
    exitapp
Return

changcolor:
    Gui,RGB: Default
    Gui,RGB:Submit, nohide
    Color_Hex := StrReplace(Color_Hex, "#", "")
    Color_RGB := Hex2RGB(Color_Hex)
    Color_RGB := "RGB(" Color_RGB ")"
    GuiControl,RGB:text, Color_RGB, %Color_RGB%
    GuiControl,RGB: +c%Color_Hex%, probar
return

Hex2RGB(_hexRGB, _delimiter="")
{
    local color, r, g, b, decimalRGB

    If _delimiter =
        _delimiter = ,
    color += "0x" . _hexRGB
    b := color & 0xFF
    g := (color & 0xFF00) >> 8
    r := (color & 0xFF0000) >> 16
    decimalRGB := r _delimiter g _delimiter b
Return decimalRGB
}

RGB2Hex(_decimalRGB, _delimiter="")
{
    local weight, color, hexRGB

    If _delimiter =
        _delimiter = ,
    weight = 16
    BackUp_FmtInt := A_FormatInteger
    SetFormat Integer, Hex
    color := 0x1000000
    Loop Parse, _decimalRGB, %_delimiter%
    {
        color += A_LoopField << weight
        weight -= 8
    }
    StringTrimLeft hexRGB, color, 3
    SetFormat Integer, %BackUp_FmtInt%
Return hexRGB
}

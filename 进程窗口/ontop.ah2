#Requires AutoHotkey >=2.0 ;修改ahk版本
#t:: ontop()
ontop(){
static Borderon:=False
static wintitle:=False
static guiborder:=False
click
    If BorderOn
    {
        WinSetAlwaysontop(0, WinTitle)
        BorderOn := False
				guiborder.destroy()
    }
    Else
    {
        MouseGetPos(, , &WinID)
        WinTitle := "ahk_id " . WinID
        WinSetAlwaysontop(1, WinTitle)
        BorderOn := True
border_thickness := "5"
border_color := "FF0000"
WinGetPos(&x, &y, &w, &h, WinTitle)
if (x="")
    return
guiborder := Gui()
guiborder.Opt("+Lastfound +AlwaysOnTop +Toolwindow -Caption")

    outerX:=0
    outerY:=0
    outerX2:=w+2*border_thickness
    outerY2:=h+2*border_thickness

    innerX:=border_thickness
    innerY:=border_thickness
    innerX2:=border_thickness+w
    innerY2:=border_thickness+h

    newX:=x-border_thickness
    newY:=y-border_thickness
    newW:=w+2*border_thickness
    newH:=h+2*border_thickness

guiborder.backcolor:=border_color

WinSetRegion(outerX "-" outerY " " outerX2 "-" outerY " " outerX2 "-" outerY2 " " outerX "-" outerY2 " " outerX "-" outerY "    " innerX "-" innerY " " innerX2 "-" innerY " " innerX2 "-" innerY2 " " innerX "-" innerY2 " " innerX "-" innerY)

guiborder.Show("w" newW " h" newH " x" newX " y" newY " NoActivate")
}
}


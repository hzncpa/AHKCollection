;可以弄出一个没有边框的透明gui用来显示一下信息比较合适
MyGui := Gui()
MyGui.Opt("+AlwaysOnTop -Caption +ToolWindow")  ; +ToolWindow 避免显示任务栏按钮和 alt-tab 菜单项.
MyGui.BackColor := "EEAA99"  ; 可以是任何 RGB 颜色(下面会变成透明的).
MyGui.SetFont("s32")  ; 设置大字体(32 磅).
CoordText := MyGui.Add("Text", "cLime", "XXXXX YYYYY")  ; XX & YY 用来自动调整窗口大小.
; 让此颜色的所有像素透明且让文本显示为半透明(150):
WinSetTransColor(MyGui.BackColor " 150", MyGui)
SetTimer(UpdateOSD, 200)
UpdateOSD()  ; 立即进行第一次更新而不等待计时器.
MyGui.Show("x0 y400 NoActivate")  ; NoActivate 让当前活动窗口继续保持活动状态.

UpdateOSD(*)
{
    MouseGetPos &MouseX, &MouseY
    CoordText.Value := "X" MouseX ", Y" MouseY
}


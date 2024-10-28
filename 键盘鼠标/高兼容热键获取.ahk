; 原生的Gui Hotkey控件不支持，Esc键、Win键、Tab键、鼠标侧键。用自改按键实现全兼容

Gui +HwndGuiHwnd
Gui Add, Text, y+12 Section, 全兼容按键注册：
; 单击按钮设置快捷键
Gui Add, Button, ys-6 w112 v需要定义v变量 g全兼容注册热键, % 热键注册键名 := "F1"
Gui Show
Hotkey, $%热键注册键名%, 注册按键对应的标签, On
Return

注册按键对应的标签:
GuiClose:
  ExitApp

; 使鼠标侧键只对Gui窗口生效
#if WinActive("ahk_id " GuiHwnd)
~XButton1::
~XButton2::
GuiControlGet, 焦点控件名, Focus
GuicontrolGet, 按钮内容, , %焦点控件名%
if (按钮内容="请按下键盘…") {
  GuiInputHook.Stop()
  Hotkey, $%热键注册键名%, 注册按键对应的标签, Off
  热键注册键名 := StrReplace(A_ThisHotkey, "~")
  Hotkey, $%热键注册键名%, 注册按键对应的标签, On
  GuiControl,, %焦点控件名%, % StrReplace(A_ThisHotkey, "~")
}
Return
#if


全兼容注册热键:
GuiControl, , %A_GuiControl%, 请按下键盘…
GuiInputHook := InputHook("T12")
; GuiInputHook.VisibleNonText := false  ; 控制不产生文本的键或键组合是否可见(不阻塞)
GuiInputHook.KeyOpt("{All}", "E")
GuiInputHook.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}", "-E")
GuiInputHook.Start()
ComboKey := GuiInputHook.Wait()="Timeout" ? "Timeout" : GuiInputHook.EndMods . GuiInputHook.EndKey
if (ComboKey!="") {
  if (ComboKey="Backspace") or (ComboKey="Timeout") {
    GuiControl, , %A_GuiControl%, 无
    Hotkey, $%热键注册键名%, 注册按键对应的标签, Off
    热键注册键名 := ""
  } else {
    Hotkey, $%热键注册键名%, 注册按键对应的标签, Off
    热键注册键名 := ComboKey
    Hotkey, $%热键注册键名%, 注册按键对应的标签, On
    GuiControl, , %A_GuiControl%, % Format_hotkey(ComboKey)
  }
}
Return

Format_hotkey(hk) {  ; 按键名格式化为标准显示
  Return StrReplace(StrReplace(StrReplace(StrReplace(StrReplace(StrReplace(StrLen(RegExReplace(hk, "[^A-Za-z]"))=1 ? Format("{:U}", hk) : hk,"+","Shift + "),"!","Alt + "),"^","Ctrl + "),"#","Win + "),"<","L"),">","R")  ; 单字母转大写加修饰键转换
}
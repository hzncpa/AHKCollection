F1::MsgBox % GetToolTipText()

GetToolTipText(){
  WinGet, hwnd, ID, ahk_class tooltips_class32
  if hwnd
    ControlGetText, text, , ahk_id %hwnd%
  Return text
}
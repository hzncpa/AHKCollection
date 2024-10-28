SetBatchLines -1


F1::
GetRange(x, y, w, h)
; Clipboard :=  x ", " y ", " w ", " h
MsgBox % x ", " y ", " w ", " h
Return

GetRange(ByRef x="",ByRef y="",ByRef w="",ByRef h="") {  ; By dbgba
  Static HighlightOutline1
  if !HighlightOutline1
    HighlightOutline1 := new HighlightOutline("2080F0", 210)
  PrintBreak := ""
  , SetSystemCursor("CROSS")
  Hotkey, *LButton, Print_LButton_Down, On
  Hotkey, *LButton Up, Print_LButton_Up, On
  Hotkey, *RButton, Print_RButton, On
  Loop
    Sleep 100
   Until (PrintBreak=1)
  HighlightOutline1.Hide()
  Return

  Print_LButton_Down:
    WinPos := FirstPosition:= ""  ; 清除坐标字典和起点重置
    SetTimer, DrawingScreenshotArea, 30  ; 设置计时器以在捕获区域周围绘制矩形.
  Return

  Print_LButton_Up:
  Print_RButton:  ; 如果在选择屏幕剪辑区域时按下了鼠标右键，则取消操作。
    SetTimer, DrawingScreenshotArea, Off
    Hotkey, *LButton, Print_LButton_Down, Off
    Hotkey, *LButton Up, Print_LButton_Up, Off
    Hotkey, *RButton, Print_RButton, Off
    SetSystemCursor()
    , (A_ThisLabel="Print_RButton" && WinPos:="")
    , x := WinPos.X, y := WinPos.Y, w := WinPos.W, h := WinPos.H
    , PrintBreak := 1
  Return

  DrawingScreenshotArea:
    CoordMode, Mouse
    if !FirstPosition {
      FirstPosition:=1  ; 初始化第一个位置
      MouseGetPos, SX , SY ; 获取x和y的起始位置
    } else {  ; 设定第一个位置后
      MouseGetPos, EX , EY  ; 获取光标的当前位置
      if ( SX <= EX && SY <= EY )  ; 如果当前位置在起始位置的下方和右侧
        WinPos := { X: SX , Y: SY , W: EX - SX , H: EY - SY }
      else if ( SX > EX && SY <= EY )  ; 如果当前位置在起始位置的下方和左侧
        WinPos := { X: EX , Y: SY , W: SX - EX , H: EY - SY }
      else if ( SX <= EX && SY > EY)  ; 如果当前位置在起始位置的上方和右侧
        WinPos := { X: SX , Y: EY , W: EX - SX , H: SY - EY }
      else if ( SX > EX && SY > EY)  ; 如果当前位置在起始位置的上方和左侧
        WinPos := { X: EX , Y: EY , W: SX - EX , H: SY - EY }
    }
    if WinPos.W  ; 如果WinPos对象存在
      HighlightOutline1.Show(WinPos.X, WinPos.Y, WinPos.X+WinPos.W, WinPos.Y+WinPos.H)
  Return
}

SetSystemCursor(Cursor="") {  ; 设置光标
  Static SystemCursors := "32512IDC_ARROW|32513IDC_IBEAM|32514IDC_WAIT|32515IDC_CROSS|32516IDC_UPARROW|32642IDC_SIZENWSE|32643IDC_SIZENESW|32644IDC_SIZEWE|32645IDC_SIZENS|32646IDC_SIZEALL|32648IDC_NO|32649IDC_HAND|32650IDC_APPSTARTING|32651IDC_HELP"
  If (Cursor = "")
    Return DllCall("SystemParametersInfo", "UInt", 0x57, "UInt", 0, "UInt", 0, "UInt", 0)   ; SPI_SETCURSORS := 0x57
  If (StrLen(SystemCursors) = 221)
    Loop, Parse, SystemCursors, |
      StringReplace, SystemCursors, SystemCursors, %A_LoopField%, % DllCall("LoadCursor", "UInt", 0, "Int", SubStr(A_LoopField, 1, 5)) A_LoopField
  If !(Cursor := SubStr(SystemCursors, InStr(SystemCursors "|", "IDC_" Cursor "|") - 5 - p := (StrLen(SystemCursors) - 221) / 14, 5))
    MsgBox, 262160, %A_ScriptName% - %A_ThisFunc%(): Error, 无效的指针名字！
  Else
    Loop, Parse, SystemCursors, |
      DllCall("SetSystemCursor", "UInt", DllCall("CopyIcon", "UInt", Cursor), "Int", SubStr(A_LoopField, 6, p))
}

class HighlightOutline {
  __New(Color="Red", Transparent=255) {
    Loop 4 {
      Gui New, -Caption +AlwaysOnTop +ToolWindow HWNDhwnd -DPIScale +E0x20 +E0x00080000
      Gui Color, %Color%
      DllCall("SetLayeredWindowAttributes", "Ptr", this[A_Index] := hwnd, "Uint", 0, "Uchar", Transparent, "int", 2)
    }
    this.top := this[1]
    , this.right := this[2]
    , this.bottom := this[3]
    , this.left := this[4]
    Gui Gui_Cheek_Number%A_DefaultGui%: Default
  }

  Show(x1, y1, x2, y2, b=3) {
    Try Gui % this[1] ":Show", % "NA x" x1-b " y" y1-b " w" x2-x1+b*2 " h" b
    Try Gui % this[2] ":Show", % "NA x" x2 " y" y1 " w" b " h" y2-y1
    Try Gui % this[3] ":Show", % "NA x" x1-b " y" y2 " w" x2-x1+2*b " h" b
    Try Gui % this[4] ":Show", % "NA x" x1-b " y" y1 " w" b " h" y2-y1
  }

  Hide() {
    Loop 4
      Gui % this[A_Index] ": Hide"
  }

  Destroy() {
    Loop 4
      Gui % this[A_Index] ": Destroy"
  }
}
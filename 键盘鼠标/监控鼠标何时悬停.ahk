#Persistent
Hook := new WindowsHook(WH_MOUSE_LL := 14, "LowLevelMouseProc")

LowLevelMouseProc(nCode, wParam, lParam) {
   static WM_MOUSEMOVE := 0x200
   if (wParam = WM_MOUSEMOVE)
      SetTimer, MouseStop, -100
}

MouseStop() {
   SoundBeep
   ToolTip 鼠标停止移动
}

class WindowsHook {
   __New(type, callback, eventInfo := "", isGlobal := true) {
      this.pCallback := RegisterCallback(callback, "Fast", 3, eventInfo)
      this.hHook := DllCall("SetWindowsHookEx", "Int", type, "Ptr", this.pCallback
                                              , "Ptr", !isGlobal ? 0 : DllCall("GetModuleHandle", "UInt", 0, "Ptr")
                                              , "UInt", isGlobal ? 0 : DllCall("GetCurrentThreadId"), "Ptr")
   }
   __Delete() {
      DllCall("UnhookWindowsHookEx", "Ptr", this.hHook)
      DllCall("GlobalFree", "Ptr", this.pCallback, "Ptr")
   }
}

;=======================下面是鼠标实时移动情况==================================
;#InstallMouseHook
;loop
;{
;	Sleep, 10
;	Tooltip, % "Mouse " . (A_TimeIdleMouse < 50 ? "Move" : "Stop"), %CheckVarX% , %CheckVarY% - 50
;}
; WH_MOUSE_LL  := 14 ;全局鼠标钩常数  
; WH_KEYBOARD_LL := 13 ;全局键盘钩常数    

SetBatchLines, -1

Gosub, 鼠标钩子

LowLevelMouseProc(nCode, wParam, lParam) {
	ToolTip, 鼠标操作时触发
	Global MouseHook := ""
	SetTimer, 鼠标钩子, -1000
}

鼠标钩子:
MouseHook := new WindowsHook(WH_MOUSE_LL := 14, "LowLevelMouseProc")
Return


F1::
SetTimer, 鼠标钩子, Off
ToolTip
Return
;==================== 下面是类函数库 ====================
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
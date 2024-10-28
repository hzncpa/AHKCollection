Loop
  ToolTip ���̳���������ʾ-%A_Index%

F1::
Run, cmd,,, Pid
wait_obj := New WaitProcess(pid, "CallBack")
Return

F2::wait_obj := ""

; �ص�����ִ��һ�����Ҫִ�ж�������SetTimer ��ǩ��, -1
CallBack(lpParameter, timerOrWaitFired) {
    MsgBox �ر�
}

; CallBack(s:="") {
;     if !s {
;         SetTimer %s%, % -1    s:=Func(A_ThisFunc).Bind("Asynchronous")
;         Return
;     }
;     Loop 100
;         ToolTip %A_Index%
; }

Class WaitProcess {  ; By Tebayaki
  __New(pid, function, pParam := 0, timeout := -1) {
    if !hProcess := DllCall("OpenProcess", "Uint", 0x100000, "int", False, "Uint", pid, "Ptr")
      Throw Exception("Error")
    if !DllCall("RegisterWaitForSingleObject", "Ptr*", hWait:= 0, "Ptr", hProcess, "Ptr", RegisterCallback(function, "F"), "Ptr", pParam, "Uint", timeout, "Uint", 8)
      Throw Exception("Error")
    this.WaitObject := hWait
  }
  __Delete() {
    this.HasKey("WaitObject") && DllCall("UnregisterWaitEx", "Ptr", this.WaitObject, "Ptr", 0)
  }
}
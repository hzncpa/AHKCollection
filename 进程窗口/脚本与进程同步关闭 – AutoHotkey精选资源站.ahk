; 示例为：跟随启动的记事本同步退出
#NoEnv
#Persistent
SetBatchLines -1
SetWorkingDir %A_ScriptDir%

Run Notepad, , , PID

与进程同步退出(PID)

MsgBox 此进程弹窗，将跟随启动的记事本同步退出
Return



与进程同步退出(PID:="") {
  if (PID="")
    ExitApp
  else
    Return 1 DllCall("RegisterWaitForSingleObject", "Ptr*", 0, "Ptr", DllCall("OpenProcess", "Uint", 0x100000, "int", False, "Uint", PID, "Ptr"), "Ptr", RegisterCallback("与进程同步退出", "F"), "Ptr", 0, "Uint", -1, "Uint", 8)
}



/*
; 向进程传参PID进行测试
Run %A_ScriptDir%\脚本与进程同步关闭.ahk 1120

与进程同步退出( PID ) {
  Static init := 与进程同步退出( A_Args[1] )  ; 传参PID
  if init
    ExitApp
  else if (PID!="")
    Return 1 DllCall("RegisterWaitForSingleObject", "Ptr*", 0, "Ptr", DllCall("OpenProcess", "Uint", 0x100000, "int", False, "Uint", PID, "Ptr"), "Ptr", RegisterCallback("与进程同步退出", "F"), "Ptr", 0, "Uint", -1, "Uint", 8)
}
*/
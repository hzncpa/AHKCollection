; ʾ��Ϊ�����������ļ��±�ͬ���˳�
#NoEnv
#Persistent
SetBatchLines -1
SetWorkingDir %A_ScriptDir%

Run Notepad, , , PID

�����ͬ���˳�(PID)

MsgBox �˽��̵����������������ļ��±�ͬ���˳�
Return



�����ͬ���˳�(PID:="") {
  if (PID="")
    ExitApp
  else
    Return 1 DllCall("RegisterWaitForSingleObject", "Ptr*", 0, "Ptr", DllCall("OpenProcess", "Uint", 0x100000, "int", False, "Uint", PID, "Ptr"), "Ptr", RegisterCallback("�����ͬ���˳�", "F"), "Ptr", 0, "Uint", -1, "Uint", 8)
}



/*
; ����̴���PID���в���
Run %A_ScriptDir%\�ű������ͬ���ر�.ahk 1120

�����ͬ���˳�( PID ) {
  Static init := �����ͬ���˳�( A_Args[1] )  ; ����PID
  if init
    ExitApp
  else if (PID!="")
    Return 1 DllCall("RegisterWaitForSingleObject", "Ptr*", 0, "Ptr", DllCall("OpenProcess", "Uint", 0x100000, "int", False, "Uint", PID, "Ptr"), "Ptr", RegisterCallback("�����ͬ���˳�", "F"), "Ptr", 0, "Uint", -1, "Uint", 8)
}
*/
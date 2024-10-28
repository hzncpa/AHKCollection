#SingleInstance Force
#Persistent
SetBatchLines -1
SetWorkingDir %A_ScriptDir%

/*
  libԭ����  https://www.autohotkey.com/boards/viewtopic.php?t=830
  Event��
  0x1 �¼�\ϵͳ\����          0x2 �¼�\ϵͳ\����          0x3 �¼�\ϵͳ\ǰ̨
  0x4 �¼�\ϵͳ\�˵�����        0x5 �¼�\ϵͳ\�˵�          0x6 �¼�_ϵͳ_�˵���ʼ
  0x7 �¼�_ϵͳ_�˵�֧��        0x8 �¼�\ϵͳ\��������        0x9 �¼�\ϵͳ\�������
  0xA �¼�\ϵͳ\�ƶ���С����    0xB �¼�\ϵͳ\�ƶ���С        0xC �¼�\ϵͳ\�����İ�������
  0xC �¼�\ϵͳ\�����İ�����    0xD �¼�\ϵͳ\�϶�����        0xE �¼�\ϵͳ\����
  0xF �¼�\ϵͳ\�Ի�������      0x11 �¼�\ϵͳ\�Ի������    0x12 �¼�\ϵͳ\��������
  0x13 �¼�\ϵͳ\������ʾ      0x14 �¼�\ϵͳ\��������      0x15 �¼�\ϵͳ\���ض�
  0x16 �¼�\ϵͳ\��С������    0x17 �¼�\ϵͳ\��С��        0X8001 �¼�\����\����
*/

; ǰ̨����ڼ�� By ��⵸�
WinEventID:=0   ;��ʼ�����ǰ̨����ID
WinEventHook:=SetWinEventHook(0x3,0x3,0, RegisterCallback( "HookProc","F"),0,0,flag=0)  ;flag�ų��ű���Ϣ?0x1:0x0
OnExit("UnhookWinEvent")
Return

HookProc(WinEventHook, Event,hWnd,idObject,idChild,dwEventThread,dwmsEventTime ) {
  Global WinEventID
  if Event {
    if (WinEventID<>Format("0x{:x}",hWnd)&&hWnd>0){
      ;;==================���ڱ仯����====================================
      WinGetTitle, title, ahk_id %hWnd%
      
      ToolTip % "��������" title "`t" Format("0x{:x}",hWnd) "`t" WinEventID "`n`n"
      ; FileAppend,% title "`t" Format("0x{:x}",hWnd) "`t" WinEventID "`n`n",Message.txt
      ;;==============================================================
      WinEventID:=Format("0x{:x}",hWnd)
    }
  }
}

SetWinEventHook(eventMin, eventMax, hmodWinEventProc, lpfnWinEventProc, idProcess, idThread, dwFlags) {
  DllCall("CoInitialize", "Uint", 0)
  return DllCall("SetWinEventHook", "Uint",eventMin, "Uint",eventMax, "Uint",hmodWinEventProc
    , "Uint",lpfnWinEventProc
    , "Uint",idProcess
    , "Uint",idThread
    , "Uint",dwFlags)   
}

UnhookWinEvent() {
  Global WinEventHook
  Menu Tray, NoIcon
  DllCall( "UnhookWinEvent", "Uint",WinEventHook )
  DllCall( "GlobalFree", "Uint",&HookProcAdr ) ; free up allocated memory for RegisterCallback
}
; WinCloseAuto( SetHook, WEP.1, WEP.2, WEP.3, WEP.4 )
; WinCloseAuto()�����Ӻ͹رն�� 4 �����ڡ�

; ������
; SetHook������Ӧ��ʡ�ԣ�����Ӧ��ΪTrue������ Hook����FalseΪ Unhook��
; WEP.1 .. WEP.4��WinExist()��������ҪΪÿ��������Ϊ���������鴫�ݡ�
; ע�⣺WinExist()�� 4 �������������ʾ����ʹ�õ�һ������

; �÷�ʾ����
; ���´��뽫��Calculator�� Notepad��Windows Task Managerʱ�Զ��ر� ���֡�

; ���� 4 �ܵĹ۲죬�һ�˵���·������Ժܺõ����� PD ��档
; WinCloseAuto(True, ["Panda Dome ahk_exe PSUAConsole.exe",,,"Panda Dome"])
; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=77461

; ������Ƶ��ͦ�ߵģ����Ǵ����첽������
#NoEnv
#Warn
#Persistent
#SingleInstance Force

; ��һ�в����ǲ��Դ򿪼��±��Զ��ر�
WinCloseAuto(True , ["ahk_class Notepad"]
                  , ["ahk_class CalcFrame"] 
                  , ["Windows Task Manager ahk_class #32770"] )

Loop 
  ToolTip, �����̳���������ʾ-%A_Index%
return

WinCloseAuto(P*) {    ; WinCloseAuto v0.50 by SKAN on D36I/D36I @ tiny.cc/wincloseauto
  Static CBA:=RegisterCallBack("WinCloseAuto"), WEP:="", hHook:=0, EVENT_OBJECT_SHOW:=0x8002
  If IsObject(P)
    Return (P.1=1 && (WEP:=P)) ? hHook:=DllCall("SetWinEventHook","Int",EVENT_OBJECT_SHOW
          ,"Int",EVENT_OBJECT_SHOW, "Ptr",0, "Ptr",CBA, "Int",0, "Int",0, "Int",0, "Ptr")
          : (P.1=0 && (WEP:="")="") ? DllCall("UnhookWinEvent", "Ptr",hHook) : "" 
  If WinExist((WEP.2)*) || WinExist((WEP.3)*)  || WinExist((WEP.4)*) || WinExist((WEP.5)*) 
    PostMessage, 0x112, 0xF060 ;  WM_SYSCOMMAND, SC_CLOSE
}
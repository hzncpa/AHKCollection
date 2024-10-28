; WinCloseAuto( SetHook, WEP.1, WEP.2, WEP.3, WEP.4 )
; WinCloseAuto()将监视和关闭多达 4 个窗口。

; 参数：
; SetHook参数不应被省略，并且应该为True以设置 Hook，或False为 Unhook。
; WEP.1 .. WEP.4是WinExist()参数，需要为每个参数作为单独的数组传递。
; 注意：WinExist()有 4 个参数。下面的示例仅使用第一个参数

; 用法示例：
; 以下代码将在Calculator、 Notepad或Windows Task Manager时自动关闭 出现。

; 经过 4 周的观察，我会说以下方法可以很好地消除 PD 广告。
; WinCloseAuto(True, ["Panda Dome ahk_exe PSUAConsole.exe",,,"Panda Dome"])
; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=77461

; 【触发频率挺高的，不是窗口异步触发】
#NoEnv
#Warn
#Persistent
#SingleInstance Force

; 第一行参数是测试打开记事本自动关闭
WinCloseAuto(True , ["ahk_class Notepad"]
                  , ["ahk_class CalcFrame"] 
                  , ["Windows Task Manager ahk_class #32770"] )

Loop 
  ToolTip, 主进程持续运算演示-%A_Index%
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
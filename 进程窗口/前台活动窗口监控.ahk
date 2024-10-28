#SingleInstance Force
#Persistent
SetBatchLines -1
SetWorkingDir %A_ScriptDir%

/*
  lib原贴：  https://www.autohotkey.com/boards/viewtopic.php?t=830
  Event：
  0x1 事件\系统\声音          0x2 事件\系统\警报          0x3 事件\系统\前台
  0x4 事件\系统\菜单启动        0x5 事件\系统\菜单          0x6 事件_系统_菜单开始
  0x7 事件_系统_菜单支出        0x8 事件\系统\捕获启动        0x9 事件\系统\捕获结束
  0xA 事件\系统\移动大小启动    0xB 事件\系统\移动大小        0xC 事件\系统\上下文帮助启动
  0xC 事件\系统\上下文帮助端    0xD 事件\系统\拖动启动        0xE 事件\系统\拖缆
  0xF 事件\系统\对话框启动      0x11 事件\系统\对话框结束    0x12 事件\系统\滚动启动
  0x13 事件\系统\滚动显示      0x14 事件\系统\开关启动      0x15 事件\系统\开关端
  0x16 事件\系统\最小化启动    0x17 事件\系统\最小化        0X8001 事件\对象\销毁
*/

; 前台活动窗口监控 By 蜜獾哥
WinEventID:=0   ;初始化监控前台窗口ID
WinEventHook:=SetWinEventHook(0x3,0x3,0, RegisterCallback( "HookProc","F"),0,0,flag=0)  ;flag排除脚本消息?0x1:0x0
OnExit("UnhookWinEvent")
Return

HookProc(WinEventHook, Event,hWnd,idObject,idChild,dwEventThread,dwmsEventTime ) {
  Global WinEventID
  if Event {
    if (WinEventID<>Format("0x{:x}",hWnd)&&hWnd>0){
      ;;==================窗口变化操作====================================
      WinGetTitle, title, ahk_id %hWnd%
      
      ToolTip % "标题名：" title "`t" Format("0x{:x}",hWnd) "`t" WinEventID "`n`n"
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
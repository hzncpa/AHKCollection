#SingleInstance, Force
OnClipboardChange("on")
;多行的话往下加就行了
gui +E0x08000000 +AlwaysOnTop 
Gui, Add, CheckBox,vte Checked gsubmit,笔记采集开关
Gui Show,x0 y0 w250 NoActivate,笔记采集
Return
GuiClose:
GuiEscape:
ExitApp

Submit:
gui,Submit,nohide
return


on(){
  global te
  if (te==0)
    return
  static a
  if (a==Clipboard)
    return
  a:=Clipboard
	; run,"C:\Program Files\Microsoft Office\root\Office16\ONENOTE.EXE"  /paste
  WinActivate,ahk_exe notion.exe ;修改成自己需要的笔记软件
  send,^v
  sleep 200
  send !{tab}
}



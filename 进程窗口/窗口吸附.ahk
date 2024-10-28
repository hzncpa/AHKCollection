;v1 ;{{{
#Requires AutoHotkey <=2.0 ;v1
#SingleInstance Force  ;v1
re_index(){
FileGetTime last_user, %A_ScriptFullPath%, M ;v1
if ( A_now-last_user<1.5 )
		reload
}
SetKeyDelay 0
SetMouseDelay 0
settimer re_index,1000
 ;}}}
#Persistent
#SingleInstance,FORCE
宿主:="ahk_class WeChatMainWndForPC"
跟屁虫:="ahk_class EVERYTHING"

;多行的话往下加就行了
Loop
{
	WinGetClass,_ActiveTitle,A
	If instr(宿主,_ActiveTitle) 
	{
		WinGetPos , X, Y, Width, Height,%宿主%
		X1:= x+Width
		Y1:=y+Height
		winactivate %跟屁虫%
		WinMove,%跟屁虫%,,%X1%,%Y%,200,400
		WinSet, Topmost,on, %跟屁虫%
		WinRestore,%跟屁虫%
		Sleep,600
	}
	else
	{
		WinSet, AlwaysOnTop,off, %跟屁虫%
		if not instr(跟屁虫,_ActiveTitle)
		{
			WinSet, Bottom,, %跟屁虫%
		}
		WinWaitNotActive,%宿主%	
   }
}
return


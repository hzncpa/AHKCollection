;v1 or v2 ;{{{
;#Requires AutoHotkey <=2.0 ;v1
#SingleInstance Force  ;v1
#Requires AutoHotkey >=2.0 ;v2
re_index(){
;FileGetTime last_user, %A_ScriptFullPath%, M ;v1
last_user:=filegettime(A_scriptfullpath) ;v2
if ( A_now-last_user<1.5 )
		reload
}
SetKeyDelay 0
SetMouseDelay 0
settimer re_index,1000
 ;}}}


 !f1::{
	 send "^c"
	 clipwait 1,1
	 fileappend A_Clipboard,A_Temp "\" A_ComputerName "_" A_now ".ahk"
	 }

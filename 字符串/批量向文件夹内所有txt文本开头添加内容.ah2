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


;群友提到的批量给文件开头加上文本
text:=inputbox("输入需要加在开头的内容`,默认给txt添加有需求自行修改源码").value
SelectedFolder := DirSelect(, 3)
if SelectedFolder = ""
    MsgBox "You didn't select a folder."
Loop Files,SelectedFolde "\*.txt", "R"
{
	txt:=text fileread(A_LoopField)
	filedelete(A_LoopField)
	fileappend txt,A_LoopField
}
msgbox 添加完成
exitapp


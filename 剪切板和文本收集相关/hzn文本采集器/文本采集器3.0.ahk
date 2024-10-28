;配置 {{{
#SingleInstance, Force 
DetectHiddenWindows, Off  ;
#MaxMem 2048
SetBatchLines, -1
Process, Priority,, High
#MaxThreadsPerHotkey 100
#MaxHotkeysPerInterval 400
SendMode Input
SetBatchLines, -1
SetKeyDelay, -1
SetMouseDelay, -1


;}}}
;全局变量的定义 ;{{{
global content,mode,appendpath,generatePath,toggle
mode:="append" , toggle:="打开"
onclipboardchange("whichmode")
 ;}}}
;任务栏图标菜单的修改 ;{{{
Menu, Tray, Add  ; 创建分隔线.
Menu, Tray, Add,切换模式,change ; 创建新菜单项.
Menu, Tray, Add,功能总开关,toggle ; 创建新菜单项.
;Menu, Tray, Add,查看帮助,help ; 创建新菜单项.

  ;}}}
 ;指引和帮助使用 ;{{{
help=
(
# 介绍
这是一个快速收集文本的工具,(双击ctrl c)触发,大部分设置项右键任务栏图标

托盘菜单选进入追加模式，这时候就弹框，选择一个文件
之后复制就全是追加

托盘菜单选进入生成模式，这时候就弹框，选择一个路径
之后复制就全是生成，按当前时间生成文件

总开关可以关闭功能
)
 help:
 tooltip(help,-5000)
 return
 ;}}}
;自动执行到此结束
;主要功能的逻辑实现 ;{{{
	whichmode(){
		if (toggle=="打开")
			(mode=="append")?appendMode():generateMode()
	}

	appendMode(){
		global appendpath,content
		content:=content()
		if !appendpath
			fileselectfile,appendpath
		fileappend,%content%,%appendpath%
		tooltip("剪切板内容已追加到" appendpath,-10000)
	}
	
generateMode(){
	global generatePath,content
	content:=content()
	if !generatePath
			fileselectfolder,generatePath
		generatename=%generatePath%\%A_Now%.txt
		fileappend,%content%,%generatename%
		tooltip("剪切板内容已经生成为" generatename,-10000)
}




content(){
if (clipboard=="")
	msgbox,请重新复制
return clipboard "`r`n"
}

tooltip(text,time:=-1000){
tooltip,%text%
settimer,endTooltip,%time%
}
endTooltip:
tooltip
return
 ;}}}
 ;任务栏图标菜单修改简单的参数 ;{{{
^!g:: gosub change
change:
mode:=(mode=="append")?"generate":"append"
tooltip("当前的模式为" mode)
return

toggle:
toggle:=(toggle=="打开")?"关闭":"打开"
tooltip("功能" toggle)
return
 ;}}}

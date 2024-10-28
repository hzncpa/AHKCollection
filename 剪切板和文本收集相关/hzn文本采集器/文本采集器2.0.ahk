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


;脚本自检测，如果不是管理员就自动以管理员权限运行自身
if !(A_IsAdmin || InStr(DllCall("GetCommandLine", "str"), ".exe"" /r"))
    RunWait % "*RunAs " (s:=A_IsCompiled ? "" : A_AhkPath " /r ") """" A_ScriptFullPath """" (s ? "" : " /r")

;}}}
;全局变量的定义 ;{{{
iniread,select,st.ini,path,isselet
iniread,save,st.ini,mypath,default
iniread,mode,st.ini,mypath,select
global content,title,save,select
 ;}}}
;任务栏图标菜单的修改 ;{{{
Menu, Tray, Add  ; 创建分隔线.
Menu, Tray, Add,切换选择路径和默认路径保存,change ; 创建新菜单项.
Menu, Tray, Add,查看帮助,help ; 创建新菜单项.
Menu, Tray, Add,打开自动保存的设置,settings ; 创建新菜单项.
  ;}}}
;ini不存在就创建 ;{{{
myini=
(
default=
select=folder
isselect=0
)
if !fileexist("st.ini")
	fileappend,%myini%,st.ini
 ;}}}
 ;浏览器分组有需求的自己添加{{{
GroupAdd, group_browser,ahk_class IEFrame               ;IE
GroupAdd, group_browser,ahk_class ApplicationFrameWindow ;Edge
GroupAdd, group_browser,ahk_class MozillaWindowClass    ;Firefox
GroupAdd, group_browser,ahk_class QQBrowser_WidgetWin_1
GroupAdd, group_browser,ahk_exe chrome.exe               ;Chrome
GroupAdd, group_browser,ahk_exe msedge.exe
GroupAdd, group_browser,ahk_exe 115chrome.exe
GroupAdd, group_browser,ahk_exe 360ChromeX.exe
GroupAdd, group_browser,ahk_exe vivaldi.exe
 ;}}}
 ;指引和帮助使用 ;{{{
help=
(
# 关于
这是一个快速收集文本的工具,(双击ctrl c)触发,大部分设置项右键任务栏图标
# 介绍
1. 默认路径直接存过去,可文件追加和新建
2. 弹窗选择路径,分为文件和文件夹选择,自动记住上次是文件夹还是文件
只需要esc或者x掉当前的选择框就能切换另一种选择框
这里就可以自由调用lis了肯定比自己做的gui好用
可以在任务栏的菜单切换手动两种模式
# 其他细节
可在任务栏图标菜单中查询帮助
)
 help:
 tooltip(help,-5000)
 return
 ;}}}
;自动执行到此结束
;主要功能的逻辑实现 ;{{{
append:
		if ifDirectory(save){
			title:=title() , save:=save "\" title
			SplitPath,save, name, dir, ext, name_no_ext, drive
			save:=(ext=="")?save ".txt":fullname
			}
			if( save=="" )
				return
			fileappend,%content%,%save%
		tooltip("剪切板内容已经保存在" save,-10000)
return


~^c::
(select)?doublepress("saveSelect"):DoublePress("saveDefault")
return

    DoublePress(GoFunc := ""){
        static pressed1 = 0
        if (pressed1 and A_TimeSincePriorHotkey <= 500){
            pressed1 = 0
            SetTimer, %GoFunc%, -10
        }
        else {
            pressed1 = 1
        }
    }

saveDefault(){
	global save,content
	content:=content()
		gosub append
		return
}

saveSelect(){
if( mode=="file" ){
	fileselectfile,save
	if( save=="" )
		fileselectfolder,save
	}else if( mode=="folder" ){
		fileselectfolder,save
		if( save=="" )
			fileselectfile,save
}
gosub append
	}

title(){
if (winactive("ahk_group group_browser")){
	send yl
	clipwait,1,1
	return clipboard
}else
	inputbox,title
return title
}

ifDirectory(mypath){
	return ( instr(fileexist(mypath),"D") )?true:false
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

change:
iniread,select,st.ini,mypath,isselect
if select{
	tooltip("切换为默认路径保存")
	iniwrite,0,st.ini,mypath,isselect
	select:=0
}else{
	tooltip("切换为选择路径保存")
	iniwrite,1,st.ini,mypath,isselect
	select:=1
}
return

 ;}}}

;include的时候不要把这个放在顶部
; 之前使用这个文件来存储一些命令脚本,目前已废弃
;autoexec; {{{
#SingleInstance, Force
DetectHiddenWindows, Off  ;找窗口相关
;一些影响速度的
#MaxMem 2048
SetBatchLines, -1
Process, Priority,, High
#MaxThreadsPerHotkey 100
#MaxHotkeysPerInterval 400
SendMode Input
SetBatchLines, -1
SetKeyDelay, -1
SetMouseDelay, -1
CoordMode, ToolTip, Screen
; 检查标签是否存在
if (A_ScriptName = "hzn.ahk") {
if IsLabel(A_Args[1]) 
	gosub % A_Args[1]
else if A_Args[1]!=""
	MsgBox,% "error,the args1=" A_Args[1]
 else if A_Args[1]="" 
	gosub build_em
}
ExitApp
; }}}
;build em cmd{{{

/*
README
A_Args[1] the name of the command
A_Args[2] the path of files
*/
build_em: ;不显示
all:=""
loop, Read, %A_ScriptFullPath%  ; 逐行读取自身文件内容
{
	FileReadLine, line, %A_ScriptFullPath%,%A_Index%
	注释:=RegExReplace(line,"^([^;]+):(\s+;.+)?$","$2")
	name:=RegExReplace(line,"^([^;]+):(\s+;.+)?$","$1")
    if (line = ";结束em命令读取")
        break  ; 如果行内容为";"，则跳出整个循环
	if (RegExMatch(line, "^([^;]+):(\s+;.+)?$") && !InStr(注释,"不显示"))  ; 使用给定的正则表达式进行匹配
	{
		;name:=RegExReplace(name,"^name=(.+)$","$1")
		name:= StrReplace(name, " ", "")  ; 删除空格
		FileReadLine,Menu,%A_ScriptFullPath%,% A_Index+1
		FileReadLine,param,%A_ScriptFullPath%,% A_Index+2
		param1:=RegExReplace(param,"^(;*\s*param=)(.+)$"," $2")
		param:="param= " . name . param1
		FileReadLine,button,%A_ScriptFullPath%,% A_Index+3
		FileReadLine,iconic,%A_ScriptFullPath%,% A_Index+4
		if (!InStr(button,"button="))
			button:="button="
		if (!InStr(iconic,"iconic="))
			iconic:="iconic=1"
			exe :=A_ScriptFullPath
		tem=
		(
[em_%name%]
%menu%
cmd=%exe%
%param%
%button%
%iconic%

		)
		all:=all . "`n" . tem
	}
}

; 获取当前执行脚本的目录
scriptDir := A_ScriptDir
; 构造文件路径
filePath := scriptDir . "\em.txt"
; 检查文件是否存在
if FileExist(filePath)
{
	; 删除已存在的文件
	FileDelete, %filePath%
}
; 追加内容到文件
FileAppend, %all%, %filePath%
; 确认追加成功
if ErrorLevel
	MsgBox, 追加文件时遇到错误。
else
	MsgBox,% all
ExitApp
; }}}
;tc; {{{
javdbSearch:
Menu=search in javdb
param=%P%S
tc_cmd("em_CopyJustFileName")
sleep 100
number:=RegExReplace(Clipboard,".*?@*?([a-zA-Z]+-\d{2,6}).*","$1")
run,https://javdb.com/search?q=%number%
return

 ;}}}
;结束em命令读取


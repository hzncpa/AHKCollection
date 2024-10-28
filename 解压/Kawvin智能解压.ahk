#NoEnv
#Warn
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
global SouStartDir:=
global DirStartDir:=
global 7zApp:=A_ScriptDir . "\7z\7z.exe"
global RarApp:=A_ScriptDir . "\winrar\rar.exe"
global PswTxt:=A_ScriptDir . "\密码列表.txt"
global IgnoreTxt:=A_ScriptDir . "\忽略列表.txt"
global Gui_Source:=
global Gui_IgnoreFiles:=
global Gui_KeepOrigin:=0
global Gui_AutoCheck:=
global Ky_RecentPWS:=                   ;最近可用的解压密码
if 0 > 0
{
	Gui_Source = %1% ;RegExReplace(%2%,"`n$","",all)
}

Gui Add, GroupBox, x8 y6 w463 h450, 解压文件夹下所有压缩文件
Gui Add, Text, x20 y25 w120 h23 +0x200, 存放压缩文件的目录：
Gui Add, Button, x143 y23 w33 h25, 1...
Gui Add, CheckBox, x180 y23 w128 h23 vGui_ExtractDel, 解压后删除压缩文件
Gui Add, Button, x385 y24 w75 h23 Default , 开始解压
Gui Add, Edit, x17 y50 w444 h70 vGui_Source  ;gEdit_Source'
GuiControl,,Gui_Source,%Gui_Source%

Gui Add, Text, x20 y126 w120 h23 +0x200, 解压后的文件存放到：
Gui Add, Button, x143 y125 w33 h25, 2...
Gui Add, CheckBox, Disabled x180 y128 w186 h23 vGui_KeepOrigin gChb_KeepOrigin, 保持原压缩文件中的文件夹结构
Gui Add, Button, x385 y127 w75 h23, 密码管理
Gui Add, Edit, x17 y153 w444 h21 vGui_Direction ;gEdit_Direction
Gui Add, Text, x20 y180 w158 h23 +0x200, 按压缩文件名创建新文件夹：
Gui Add, DropDownList, Disabled x183 y180 w73 vGui_CreatFolder, |
Gui Add, CheckBox, checked x270 y180 w180 h23 vGui_AutoCheck gChb_AutoCheck, 自动判断文件夹结构

Gui Add, Text, x20 y208 w125 h23 +0x200,解压后删除的文件列表：
Gui Add, CheckBox, checked x165 y208 w90 h23 vGui_DelDefindFiles, 删除列表文件
Gui Add, CheckBox, checked x270 y208 w90 h23 vGui_DelEmptyDir, 删除空文件夹
Gui Add, Button, x370 y208 w90 h23, 编辑删除列表
Gui Add, Edit, x17 y235 w444 h210 vGui_IgnoreFiles  ;gEdit_AddFiles

Gui Show, w481 h465, Kawvin智能解压-7z版本
MySub_ReloadIgnoreList()		;加载忽略列表
if 0 > 0
{
	Gui_Direction:=MyFun_GetDefaultExtractDir(2)
	GuiControl,,Gui_Direction,%Gui_Direction%
}
return

Button1...:		;添加要解压的文件所有目录
	{
		;~ GuiControlGet,Gui_Source,,Gui_Source
		;~ if Gui_Source!=
		;~ {
			;~ loop,Parse,Gui_Source,`n     ;循环读取每一行
			;~ {
				;~ MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
				;~ SplitPath,MyTemFile,,MyOutDir
				;~ SouStartDir:=MyOutDir
				;~ break
			;~ }
		;~ }
		SouStartDir:=MyFun_GetDefaultExtractDir(1)
		if SouStartDir!=
			FileSelectFolder, f_Folder , *%SouStartDir%, , 请选择 【压缩文件所在的目录】
		else
			FileSelectFolder, f_Folder , *%A_WorkingDir%, , 请选择 【压缩文件所在的目录】
	
		if f_Folder <>
		{
			FileList =
			loop, Files, %f_Folder%\*.rar
				FileList = %FileList%%A_LoopFileFullPath%`n
			loop, Files, %f_Folder%\*.zip
				FileList = %FileList%%A_LoopFileFullPath%`n
			loop, Files, %f_Folder%\*.7z
				FileList = %FileList%%A_LoopFileFullPath%`n
			;msgbox % FileList
			FileList:=RegExReplace(FileList,"`n{2,}","`n",all)
			FileList:=RegExReplace(FileList,"`n$","",all)
			;sort,%FileList%
			;msgbox % FileList
			GuiControl,,Gui_Source,%FileList%
		}
		else
			return
		return
	}

Button开始解压:
{
	Gui,Submit,NoHide
	if Gui_AutoCheck=0		;如果不自动判断文件夹结构
	{
		loop,Parse,Gui_Source,`n     ;循环读取每一行
		{
			IfExist,ZipDone.txt
				FileDelete,ZipDone.txt
			HavePSW:=0
			MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
			if InStr(FileExist(MyTemFile), "D")     ;如果是文件夹就继续
				continue
			SplitPath,MyTemFile,,MyOutDir,MyOutExt,MyOutNameNoExt
			StringLower, MyOutExt, MyOutExt
			;如果是zip,rar,7z则处理
			if (MyOutExt="zip" or  MyOutExt="rar" or MyOutExt="7z")
			{
				if Gui_Direction=        ;如果解压目录为空，则解压在文件所在目录
					Gui_Direction:=MyOutDir
				if Ky_RecentPWS!=       ;如果最近密码存在
				{
					if Gui_KeepOrigin=1		;保持原文件夹结构
					{
						if Gui_CreatFolder=是
							MyCmdLine=%comspec% /c %7zApp% x `"%MyTemFile%`" -aoa -p%Ky_RecentPWS% -o`"%Gui_Direction%\%MyOutNameNoExt%\`" && echo ZipDone>ZipDone.txt
						else
							MyCmdLine=%comspec% /c %7zApp% x `"%MyTemFile%`" -aoa -p%Ky_RecentPWS% -o`"%Gui_Direction%\`" && echo ZipDone>ZipDone.txt
					} else {
						MyCmdLine=%comspec% /c %7zApp% e `"%MyTemFile%`" -aoa -p%Ky_RecentPWS% -o`"%Gui_Direction%\`" && echo ZipDone>ZipDone.txt
					}
					RunWait,%MyCmdLine%,,UseErrorLevel
					IfExist,ZipDone.txt
					{
						FileDelete,ZipDone.txt
						if Gui_ExtractDel=1
							FileDelete, %MyTemFile%
						continue
					}
				}
				loop,Read,%PswTxt%
				{
					IfExist,ZipDone.txt
						FileDelete,ZipDone.txt
					MyPSW := RegExReplace(A_LoopReadLine,"(.*)\r.*","$1")
					if MyPSW=   ;如果是空行就继续
						continue
					if Gui_KeepOrigin=1		;保持原文件夹结构
					{
						if Gui_CreatFolder=是
							MyCmdLine=%comspec% /c %7zApp% x `"%MyTemFile%`" -aoa -p%MyPSW% -o`"%Gui_Direction%\%MyOutNameNoExt%\`" && echo ZipDone>ZipDone.txt
						else
							MyCmdLine=%comspec% /c %7zApp% x `"%MyTemFile%`" -aoa -p%MyPSW% -o`"%Gui_Direction%\`" && echo ZipDone>ZipDone.txt
					} else  {
						MyCmdLine=%comspec% /c %7zApp% e `"%MyTemFile%`" -aoa -p%MyPSW% -o`"%Gui_Direction%\`" && echo ZipDone>ZipDone.txt
					}
					RunWait,%MyCmdLine%,,UseErrorLevel
					IfExist,ZipDone.txt
					{
						HavePSW:=1
						Ky_RecentPWS:=MyPSW
						FileDelete,ZipDone.txt
						if Gui_ExtractDel=1
							FileDelete, %MyTemFile%
						break
					}
				}
				if HavePSW=0
				{
	MyReStart1:
					InputBox, MyInput, `n提示,%MyTemFile%`n`n在密码列表中未找到密码，请输入密码`n如果密码形式为 xxxx`|x，则记录密码
					If MyInput=		;如果没有输入，则解压下一个
						continue
					StringSplit,MyArray_PSW,MyInput,`|
					if Gui_KeepOrigin=1		;保持原文件夹结构
					{
						if Gui_CreatFolder=是
							MyCmdLine=%comspec% /c %7zApp% x `"%MyTemFile%`" -aoa -p%MyArray_PSW1% -o`"%Gui_Direction%\%MyOutNameNoExt%\`" && echo ZipDone>ZipDone.txt
						else
							MyCmdLine=%comspec% /c %7zApp% x `"%MyTemFile%`" -aoa -p%MyArray_PSW1% -o`"%Gui_Direction%\`" && echo ZipDone>ZipDone.txt
					} else {
						MyCmdLine=%comspec% /c %7zApp% e `"%MyTemFile%`" -aoa -p%MyArray_PSW1% -o`"%Gui_Direction%\`" && echo ZipDone>ZipDone.txt
					}
					RunWait,%MyCmdLine%,,UseErrorLevel
					IfNotExist,ZipDone.txt
					{
						MsgBox,4,操作选择,密码不正确，是否重新输入？
						IfMsgBox Yes
							goto,MyRestart1
					}
					;msgbox % instr(MyInput,"|")
					;msgbox % MyArray_PSW2
					if (instr(MyInput,"|")>0 and MyArray_PSW2!="" )  ;如果密码形式为xxxx|x,则记录密码
						FileAppend,`n%MyArray_PSW1%`n,%PswTxt%
				}
				if Gui_ExtractDel=1
					FileDelete, %MyTemFile%,1
			}
		}
		if Gui_DelDefindFiles=1
			{
				loop,parse,Gui_IgnoreFiles,`n
				{
					MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
					MyCmdLine=%comspec% /c cd /d "%Gui_Direction%\" && del /s /q "%MyTemFile%"
					;msgbox % MyCmdLine
					Run,%MyCmdLine%,,Hide
				}
			}
			;以下代码删除空文件夹
			if Gui_DelEmptyDir=1
			{
				;取得当前目录下所有目录列表
				DirList:=
				loop,Files,%Gui_Direction%\*.*,DR
					DirList=%DirList%%A_LoopFileFullPath%`n
				;遍历上面取到的目录列表，如果目录下无文件，则删除
				loop,Parse,DirList,`n
				{
					if A_LoopField=
						continue
					DFList:=
					loop,Files,%A_LoopField%\*.*,FDR
					{
						DFList=%DFList%%A_LoopFileFullPath%`n
					}
					if DFList=
						FileRemoveDir,%A_LoopField%
			}
		}
	}
	if Gui_AutoCheck=1		;如果自动判断文件夹结构
	{
		loop,Parse,Gui_Source,`n     ;循环读取每一行
		{
			IfExist,ZipDone.txt
				FileDelete,ZipDone.txt
			HavePSW:=0
			MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
			if InStr(FileExist(MyTemFile), "D")     ;如果是文件夹就继续
				continue
			SplitPath,MyTemFile,,MyOutDir,MyOutExt,MyOutNameNoExt
			StringLower, MyOutExt, MyOutExt
			;如果是zip,rar,7z则处理
			if (MyOutExt="zip" or  MyOutExt="rar" or MyOutExt="7z")
			{
				;━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
				;以下代码分析文件夹结构
				IntUnZip_Many_In_FirstLevel:=0
				IntUnZip_Folder_In_FirstLevel:=0
				IntUnZip_Folder_In_SecondLevel:=0
				aaaa:=
				bbbb:=
				Count:=1
				IntUnZip_FileLists=Kawvin_Ext_%A_Now%.txt
				Runwait, %Comspec% /C %7zApp% L "%MyTemFile%" `>"%IntUnZip_FileLists%",,hide
				;━━━━━━━━━━━━━━━━━━━━━
				Loop,read,%IntUnZip_FileLists%
				{
					FileLineStr:=a_loopreadline
					;如果包含要删除指定的文件，则跳过本行继续
					JumpThisLine:=0
					if Gui_DelDefindFiles=1
					{
						loop,parse,Gui_IgnoreFiles,`n
						{
							if instr(FileLineStr,A_loopfield)>0
							{
								JumpThisLine:=1
								break
							}
						}
					}
					if JumpThisLine=1	;如果有要删除的内容，则跳过继续
						continue
					If(regexmatch(FileLineStr,"^\d{4}-\d{2}-\d{2}"))
					{
						If( Instr(FileLineStr,"D")=21 )  			;本行如果包含D标志，则判定为文件夹
						{
							if  Instr(FileLineStr,"\")	>0		
							{
								IntUnZip_Folder_In_SecondLevel=1		;本行如果包含\标志，则判定还有2级文件夹
								break
							}
							else
								IntUnZip_Folder_In_FirstLevel=1		;本行如果包含D标志，则判定1级文件夹
						}
						if (substr(FileLineStr,21,1)!=" ")
						{
							aaaa:=RegExReplace(FileLineStr,"^\d{4}-\d{2}-\d{2}.{43}(.*?)(\\.*|$)","$1")
							If(bbbb != aaaa  And  bbbb!="" )
							{
				; 				MsgBox %aaaa%`n%bbbb%
								IntUnZip_Many_In_FirstLevel=1
								break
							}
							bbbb:=aaaa
						}
					}
				}
				;Filedelete,%IntUnZip_FileLists%
			;━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
				if Gui_Direction=        ;如果解压目录为空，则解压在文件所在目录
					Gui_Direction:=MyOutDir
				if Ky_RecentPWS!=       ;如果最近密码存在
				{
					if (IntUnZip_Folder_In_SecondLevel=1 or IntUnZip_Many_In_FirstLevel=1)		;有多层文件夹,或首层有多个文件
						MyCmdLine=%comspec% /c %7zApp% e `"%MyTemFile%`" -aoa -p%Ky_RecentPWS% -o`"%Gui_Direction%\%aaaa%\`" && echo ZipDone>ZipDone.txt
					else 
						MyCmdLine=%comspec% /c %7zApp% e `"%MyTemFile%`" -aoa -p%Ky_RecentPWS% -o`"%Gui_Direction%\`" && echo ZipDone>ZipDone.txt
					;MsgBox % MyCmdLine
					RunWait,%MyCmdLine%,,UseErrorLevel
					IfExist,ZipDone.txt
					{
						FileDelete,ZipDone.txt
						if Gui_ExtractDel=1
							FileDelete, %MyTemFile%
						continue
					}
				}
				loop,Read,%PswTxt%
				{
					IfExist,ZipDone.txt
						FileDelete,ZipDone.txt
					MyPSW := RegExReplace(A_LoopReadLine,"(.*)\r.*","$1")
					if MyPSW=   ;如果是空行就继续
						continue
					if (IntUnZip_Folder_In_SecondLevel=1 or IntUnZip_Many_In_FirstLevel=1)		;有多层文件夹,或首层有多个文件
						MyCmdLine=%comspec% /c %7zApp% e `"%MyTemFile%`" -aoa -p%MyPSW% -o`"%Gui_Direction%\%aaaa%\`" && echo ZipDone>ZipDone.txt
					else
						MyCmdLine=%comspec% /c %7zApp% e `"%MyTemFile%`" -aoa -p%MyPSW% -o`"%Gui_Direction%\`" && echo ZipDone>ZipDone.txt
					;MsgBox % MyCmdLine
					RunWait,%MyCmdLine%,,UseErrorLevel
					IfExist,ZipDone.txt
					{
						HavePSW:=1
						Ky_RecentPWS:=MyPSW
						FileDelete,ZipDone.txt
						if Gui_ExtractDel=1
							FileDelete, %MyTemFile%
						break
					}
				}
				if HavePSW=0
				{
MyReStart2:
					InputBox, MyInput, `n提示,%MyTemFile%`n`n在密码列表中未找到密码，请输入密码`n如果密码形式为 xxxx`|x，则记录密码
					If MyInput=		;如果没有输入，则解压下一个
						continue
					StringSplit,MyArray_PSW,MyInput,`|
					if (IntUnZip_Folder_In_SecondLevel=1 or IntUnZip_Many_In_FirstLevel=1)		;有多层文件夹,或首层有多个文件
						MyCmdLine=%comspec% /c %7zApp% e `"%MyTemFile%`" -aoa -p%MyArray_PSW1% -o`"%Gui_Direction%\%aaaa%\`" && echo ZipDone>ZipDone.txt
					else
						MyCmdLine=%comspec% /c %7zApp% e `"%MyTemFile%`" -aoa -p%MyArray_PSW1% -o`"%Gui_Direction%\`" && echo ZipDone>ZipDone.txt
					;MsgBox % MyCmdLine
					RunWait,%MyCmdLine%,,UseErrorLevel
					IfNotExist,ZipDone.txt
					{
						MsgBox,4,操作选择,密码不正确，是否重新输入？
						IfMsgBox Yes
							goto,MyRestart2
					}
					;msgbox % instr(MyInput,"|")
					;msgbox % MyArray_PSW2
					if (instr(MyInput,"|")>0 and MyArray_PSW2!="" )  ;如果密码形式为xxxx|x,则记录密码
						FileAppend,`n%MyArray_PSW1%`n,%PswTxt%
				}
				if Gui_ExtractDel=1
					FileDelete, %MyTemFile%,1
			}
		}
	}
	IfExist,ZipDone.txt
		FileDelete,ZipDone.txt
	;以下代码删除指定的文件
	if Gui_DelDefindFiles=1
	{
		loop,parse,Gui_IgnoreFiles,`n
		{
			MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
			MyCmdLine=%comspec% /c cd /d "%Gui_Direction%\" && del /s /q "%MyTemFile%"
			;msgbox % MyCmdLine
			Run,%MyCmdLine%,,Hide
		}
	}
	;以下代码删除空文件夹
	if Gui_DelEmptyDir=1
	{
		;取得当前目录下所有目录列表
		DirList:=
		loop,Files,%Gui_Direction%\*.*,DR
			DirList=%DirList%%A_LoopFileFullPath%`n
		;遍历上面取到的目录列表，如果目录下无文件，则删除
		loop,Parse,DirList,`n
		{
			if A_LoopField=
				continue
			DFList:=
			loop,Files,%A_LoopField%\*.*,FDR
			{
				DFList=%DFList%%A_LoopFileFullPath%`n
			}
			if DFList=
				FileRemoveDir,%A_LoopField%
		}
	}
	return
}

button2...:		;解压后的文件存放目录
	{
		;~ GuiControlGet,Gui_Source,,Gui_Source
		;~ if Gui_Source!=
		;~ {
			;~ loop,Parse,Gui_Source,`n     ;循环读取每一行
			;~ {
				;~ MyTemFile := RegExReplace(A_loopfield,"(.*)\r.*","$1")
				;~ SplitPath,MyTemFile,,MyOutDir
				;~ DirStartDir:=MyOutDir
				;~ break
			;~ }
		;~ }
		DirStartDir:=MyFun_GetDefaultExtractDir(1)
		if DirStartDir!=
			FileSelectFolder, f_Folder , *%DirStartDir%, , 请选择 【解压后的文件存放目录】
		else
			FileSelectFolder, f_Folder , *%A_WorkingDir%, , 请选择 【解压后的文件存放目录】
		if f_Folder <>
			GuiControl,,Gui_Direction,%f_Folder%
		else
			return
		return
	}
	
Chb_KeepOrigin()
{
	GuiControlGet,Gui_KeepOrigin,,Gui_KeepOrigin
	;gui,Submit,nohide
	if Gui_KeepOrigin=1 		;选中
	{
		GuiControl,enabled,Gui_CreatFolder,
		GuiControl,,Gui_CreatFolder, |
		GuiControl,,Gui_CreatFolder, 是|否||
	}
	if Gui_KeepOrigin=0		;未选中
	{
		GuiControl,Disabled,Gui_CreatFolder,
		GuiControl,,Gui_CreatFolder, |
	}
	return
}

Chb_AutoCheck()
{
	GuiControlGet,Gui_AutoCheck,,Gui_AutoCheck
	;gui,Submit,nohide
	if Gui_AutoCheck=0 		;未选中
	{
		GuiControl,enabled,Gui_KeepOrigin,
		GuiControl,enabled,Gui_CreatFolder,
		GuiControl,,Gui_KeepOrigin,1
		GuiControl,,Gui_CreatFolder, |
		GuiControl,,Gui_CreatFolder, 是|否||
	}
	if Gui_AutoCheck=1		;选中
	{
		GuiControl,Disabled,Gui_KeepOrigin,
		GuiControl,Disabled,Gui_CreatFolder,
		GuiControl,,Gui_KeepOrigin,0
		GuiControl,,Gui_CreatFolder, |
	}
	return
}

button密码管理:
	{
		IfNotExist ,%PswTxt%
			FileAppend,,%PswTxt%
		Run,%PswTxt%
		return
	}

button编辑删除列表:
{
	IfNotExist ,%IgnoreTxt%
		FileAppend,,%IgnoreTxt%
	RunWait,%IgnoreTxt%
	MySub_ReloadIgnoreList()
	return
}

MySub_ReloadIgnoreList()
{
	IfnotExist %IgnoreTxt%	;如果没有忽略列表，则新建并退出
	{
		FileAppend,,%IgnoreTxt%
		return
	}
	Gui_IgnoreFiles:=""
	loop,Read,%IgnoreTxt%
	{
		if trim(A_LoopReadLine) !=""
		{
			MyTemTxt:= trim(RegExReplace(A_LoopReadLine,"(.*)\r.*","$1")	)
			Gui_IgnoreFiles= %Gui_IgnoreFiles%%MyTemTxt%`n
		}	
	}
	Gui_IgnoreFiles:=RegExReplace(Gui_IgnoreFiles,"\s*$","")	;删除最后一个空白行
	GuiControl,,Gui_IgnoreFiles,
	GuiControl,,Gui_IgnoreFiles,%Gui_IgnoreFiles%
	return
}

MyFun_GetDefaultExtractDir(IsSouDir=1)
{
	GuiControlGet,Gui_Source,,Gui_Source
	if Gui_Source!=
	{
		loop,Parse,Gui_Source,`n     ;循环读取每一行
		{
			MyTemFile1 := RegExReplace(A_loopfield,"(.*)\r.*","$1")
			SplitPath,MyTemFile1,,MyOutDir1
			if IsSouDir=1
				return % MyOutDir1
			if IsSouDir=2
				return % MyOutDir1 . "\已解压的文件\"
			break
		}
	}
	return
}

GuiEscape:
GuiClose:
	ExitApp
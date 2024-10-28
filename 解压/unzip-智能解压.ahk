;~~~~~~~~~~~~~~~~~~~~万年书妖~~~~~~~~~~~~~~~~~~~~
;作者:			万年书妖 wannianshuyao@qq.com
;用于candy，任何传报或改编，请保留作者信息

;Version 1.9
;1、如果压缩版内只有一个文件，则是否覆盖，交给7z提问处理
;2、如果有且仅有一个文件夹，解压缩；若已有同名文件夹，则新建“包内文件夹名+加后缀”的文件夹处理
;3、如果有多个，以包文件夹解压缩；若已有同名文件夹，则新建“包文件名+加后缀”的文件夹处理
;~~~~~~~~~~~~~~~~~~~~万年书妖~~~~~~~~~~~~~~~~~~~~*/

;Cando_智能解压:          ;IntUnZip ======= intelligent UnZip

unzip()
{
	SetWorkingDir,%A_ScriptDir%
	selected := ReturnTypeString(SaveString)
	CandySelected :=selected.String	
	;━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	; 若灌入脚本，配合candy使用，删除上面的行即可
	;━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	
	IntUnZip_Many_In_FirstLevel:=0
	IntUnZip_Folder_In_FirstLevel:=0
	IntUnZip_FolderName_tmpa:=
	IntUnZip_FolderName_tmpb:=

	7z=Apps\7zip\7z.exe
	7zg=Apps\7zip\7zG.exe
	IntUnZip_FileLists=%a_temp%\wannianshuyao_IntUnZip_%a_now%.txt
	
	Splitpath ,CandySelected,,IntUnZip_FileDir,,IntUnZip_FileNameNoExt,IntUnZip_FileDrive
	DriveSpaceFree , IntUnZip_FreeSpace, %IntUnZip_FileDrive%
	FileGetSize, IntUnZip_FileSize, %CandySelected%, M
	If ( IntUnZip_FileSize > IntUnZip_FreeSpace )
	{
		MsgBox 磁盘空间不足,请检查后再解压。`n------------`n压缩包大小为%IntUnZip_FileSize%M`n剩余空间为%IntUnZip_FreeSpace%M
		Return
	}
	Runwait, %Comspec% /C %7Z% L "%CandySelected%" `>"%IntUnZip_FileLists%",,hide

	;━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	Loop,read,%IntUnZip_FileLists%
	{
		If(regexmatch(a_loopreadline,"^(\d\d\d\d-\d\d-\d\d)"))
		{
			If( Instr(a_loopreadline,"d")=21 Or Instr(a_loopreadline,"\"))  ;本行如果包含\或者有d标志，则判定为文件夹
			{
				IntUnZip_Folder_In_FirstLevel=1
			}
			If Instr(a_loopreadline,"\")
				Stringmid,IntUnZip_FolderName_tmpa,a_loopreadline,54,instr(a_loopreadline,"\")-54
			Else
				Stringtrimleft,IntUnZip_FolderName_tmpa,a_loopreadline,53
			If((IntUnZip_FolderName_tmpb != IntUnZip_FolderName_tmpa ) And ( IntUnZip_FolderName_tmpb!="" ))
			{
				IntUnZip_Many_In_FirstLevel=1
				Break
			}
			IntUnZip_FolderName_tmpb:=IntUnZip_FolderName_tmpa
		}
	}
	Filedelete,%IntUnZip_FileLists%
	;━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	If(IntUnZip_Many_In_FirstLevel=0 && IntUnZip_Folder_In_FirstLevel=0 )   ;压缩文件内，首层有且仅有一个文件
	{
		Run, %7Zg% X "%CandySelected%" -O"%IntUnZip_FileDir%"    ;覆盖还是改名，交给7z
	}
	Else If(IntUnZip_Many_In_FirstLevel=0 && IntUnZip_Folder_In_FirstLevel=1 )   ;压缩文件内，首层有且仅有一个文件夹
	{
		Ifexist,%IntUnZip_FileDir%\%IntUnZip_FolderName_tmpa%   ;已经存在了以“首层文件夹命名”的文件夹，怎么办？
		{
			Loop
			{
				IntUnZip_newfoldername=%IntUnZip_FileDir%\%IntUnZip_FolderName_tmpa%( %A_index% )
				If !Fileexist( IntUnZip_newfoldername )
				{
					Run, %7Zg% X "%CandySelected%"   -O"%IntUnZip_newfoldername%"
					Break
				}
			}
		}
		Else  ;没有“首层文件夹命名”的文件夹，那就太好了
		{
			Run, %7Zg% X "%CandySelected%" -O"%IntUnZip_FileDir%"
		}
	}
	Else  ;压缩文件内，首层有多个文件夹
	{
		Ifexist %IntUnZip_FileDir%\%IntUnZip_FileNameNoExt%  ;已经存在了以“IntUnZip_FileNameNoExt”的文件夹，怎么办？
		{
			Loop
			{
				IntUnZip_newfoldername=%IntUnZip_FileDir%\%IntUnZip_FileNameNoExt%( %A_index% )
				If !Fileexist( IntUnZip_newfoldername )
				{
					Run, %7Zg% X "%CandySelected%"   -O"%IntUnZip_newfoldername%"
					Break
				}
			}
		}
		Else ;没有，那就太好了
		{
			Run, %7Zg% X  "%CandySelected%" -O"%IntUnZip_FileDir%\%IntUnZip_FileNameNoExt%"
		}
	}
	Return   ;有，那就太好了
		{
			Run, %7Zg% X  "%CandySelected%" -O"%IntUnZip_FileDir%\%IntUnZip_FileNameNoExt%"
		}
	}
	Return
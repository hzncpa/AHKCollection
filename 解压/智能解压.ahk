/* ver=1.1
;~~~~~~~~~~~~~~~~~~~~万年书妖~~~~~~~~~~~~~~~~~~~~
1、如果压缩版内只有一个文件，则是否覆盖，交给7z提问处理
2、如果有且仅有一个文件夹，解压缩；若已有同名文件夹，则新建“包内文件夹名+加后缀”的文件夹处理
3、如果有多个，以包文件夹解压缩；若已有同名文件夹，则新建“包文件名+加后缀”的文件夹处理
;~~~~~~~~~~~~~~~~~~~~万年书妖~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~Party~~~~~~~~~~~~~~~~~~~~
; 接收参数：
;	使用 TC 的 %P%S 参数
; 使用说明：
; 1. 修改7z.exe和7zG.exe的路径
; 2. usercmd.ini添加命令：
; [em_SmartExtract]
; menu=智能解压
; cmd=改为自己SmartExtract.ahk的路径
; param=%P%S
;~~~~~~~~~~~~~~~~~~~~Party~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~脚本说明（企进专利）~~~~~~~~~~~~~~~~~~~~
原脚本为万年书妖的cando智能解压，参考Party的“SmartExtract-7z智能解压-内有使用说明.ahk”中传递参数的思路进行修改，
;~~~~~~~~~~~~~~~~~~~~脚本说明（企进专利）~~~~~~~~~~~~~~~~~~~~
*/
envget,COMMANDER_PATH,COMMANDER_PATH
global	程序路径_7Z=%A_ScriptDir%\..\Tools\7z\7z.exe
global	程序路径_7ZG=%A_scriptdir%\..\Tools\7z\7zG.exe
for n, param in A_Args  ; 对每个参数进行循环:
{
    cando_智能解压(param)
}
;━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
; 若灌入脚本，配合candy使用，删除上面的行即可
;━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
; cando_智能解压:
cando_智能解压(candyselected){
	SmartUnZip_首层多个文件标志:=0
	SmartUnZip_首层有文件夹标志:=0
	SmartUnZip_首层文件夹名:=
	SmartUnZip_文件夹名A:=
	SmartUnZip_文件夹名B:=

	包列表=%A_Temp%\wannianshuyaozhinengjieya_%A_Now%.txt

	SplitPath ,candyselected,,包目录,,包文件名
	RunWait, %comspec% /c %程序路径_7Z% l "%candyselected%" `>"%包列表%",,hide

;━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

	loop,read,%包列表%
	{
		If(RegExMatch(A_LoopReadLine,"^(\d\d\d\d-\d\d-\d\d)") And (RegExMatch(A_LoopReadLine,"(?<!files|folders)$")))
		{
			If( InStr(A_loopreadline,"D")=21 Or InStr(A_loopreadline,"\"))  ;本行如果包含\或者有D标志，则判定为文件夹
			{
				SmartUnZip_首层有文件夹标志=1
			}

			If InStr(A_loopreadline,"\")
				StringMid,SmartUnZip_文件夹名A,A_LoopReadLine,54,InStr(A_loopreadline,"\")-54
			Else
				StringTrimLeft,SmartUnZip_文件夹名A,A_LoopReadLine,53

			If((SmartUnZip_文件夹名B != SmartUnZip_文件夹名A ) And ( SmartUnZip_文件夹名B!="" ))
			{
				SmartUnZip_首层多个文件标志=1
				Break
			}
			SmartUnZip_文件夹名B:=SmartUnZip_文件夹名A
		}
	}
	FileDelete,%包列表%

;━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
	If(SmartUnZip_首层多个文件标志=0 && SmartUnZip_首层有文件夹标志=0 )   ;压缩文件内，首层有且仅有一个文件
	{
		; Run, %程序路径_7ZG% x "%candyselected%" -o "%包目录%"    ;覆盖还是改名，交给7z
		Run, %程序路径_7ZG% x "%candyselected%" -aou -o"%包目录%"    ;覆盖还是改名，交给7z
	}

	Else If(SmartUnZip_首层多个文件标志=0 && SmartUnZip_首层有文件夹标志=1 )   ;压缩文件内，首层有且仅有一个文件夹
	{
		IfExist,%包目录%\%SmartUnZip_文件夹名A%   ;已经存在了以“首层文件夹命名”的文件夹，怎么办？
		{
			Loop
			{
				SmartUnZip_NewFolderName=%包目录%\%SmartUnZip_文件夹名A%( %A_Index% )
				If !FileExist( SmartUnZip_NewFolderName )
				{
					Run, %程序路径_7ZG% x "%candyselected%"   -o"%SmartUnZip_NewFolderName%"
					break
				}
			}
		}
		Else  ;没有“首层文件夹命名”的文件夹，那就太好了
		{
			Run, %程序路径_7ZG% x "%candyselected%" -o"%包目录%"
		}
	}
	Else  ;压缩文件内，首层有多个文件夹
	{
		IfExist %包目录%\%包文件名%  ;已经存在了以“包文件名”的文件夹，怎么办？
		{
			Loop
			{
				SmartUnZip_NewFolderName=%包目录%\%包文件名%( %A_Index% )
				If !FileExist( SmartUnZip_NewFolderName )
				{
					Run, %程序路径_7ZG% x "%candyselected%"   -o"%SmartUnZip_NewFolderName%"
					break
				}
			}
		}
		Else ;没有，那就太好了
		{
			Run, %程序路径_7ZG% x  "%candyselected%" -o"%包目录%\%包文件名%"
		}
	}
	; Return
}

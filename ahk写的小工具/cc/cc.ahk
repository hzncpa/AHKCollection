#SingleInstance Force
if (A_Args[1]=="open")
	gosub mainfunc
CoordMode, Menu
SetTitleMatchMode, 3
IniRead, numlist, setting.ini, keys, keys
IniRead, Vswitchsame, setting.ini, keys, switchbetween
IniRead, hotkey1, setting.ini, hotkey1, hotkey1
IniRead, hotkey2, setting.ini, hotkey2, hotkey2
IniRead, hotkey3, setting.ini, hotkey3, hotkey3

global num
global kkk
global jjj
global liststate
liststate:=0
num:=[]
num:=StrSplit(numlist , A_Space)

Menu, Tray, NoStandard
Menu, Tray, Add, 添加固定搭配,   goguding
Menu, Tray, Add, 添加排除列表,   gopaichu
Menu, Tray, Add, 更改触发键1,   hotkey1change
Menu, Tray, Add, 更改触发键2,   hotkey2change
Menu, Tray, Add, 更改触发键3,   hotkey3change
Menu, Tray, Add, reload,   relo
Menu, Tray, Add, 退出,   exit

progname:=[]
prognum:=[]
sumdiss:=0
loop, 36
{
IniRead, kkk, setting.ini, setting, % num[A_Index]
if ! (kkk ="")
{
jjj:=A_index - sumdiss
progname[jjj]:=kkk
prognum[jjj]:=num[A_index]
numlist:= StrReplace(numlist, num[A_index] A_Space, "")
}else
sumdiss := sumdiss+1
}
num:=[]
num:=StrSplit(numlist , A_Space)

IniRead, dismisslist, setting.ini, dismiss
global num2
global locklist1
global locklist2
global locksum
global numlist2
global numlist
global if_lock
global Screen_cg
Screen_cg:=0
if_lock:=0

;$capslock::
try
hotkey,%hotkey1%,mainfunc,
Catch
{
	hotkey1:="F18"
	IniWrite,%hotkey1%, setting.ini, hotkey1, hotkey1
}	

try
hotkey,%hotkey2%,mainfunc2,
Catch
{
	hotkey2:="F19"
	IniWrite,%hotkey2%, setting.ini, hotkey2, hotkey2
}

try
hotkey,%hotkey3%,mainfunc3,
Catch
{
	hotkey3:="F21"
	IniWrite,%hotkey3%, setting.ini, hotkey3, hotkey3
}
return

mainfunc:
gosub, getallinfo
Menu, Windows, Show, %xx%,%yy%
return

mainfunc2:
gosub, getallinfo
Menu, Windows, Show, ,
return

mainfunc3:
Screen_cg:=1
gosub, getallinfo
Menu, Windows, Show, ,
return

getallinfo:
{
liststate:=1
run addons\space2enter.ahk

WinGet, activeexe, ProcessName , A
WinGetTitle, activename,A
try
Menu, Windows, delete
catch
1=1
Menu, Windows, Add
Menu, Windows, deleteAll
WinGet windows, List
sumdiss:=0
showlistlock:=""
lll:=[]

Loop %windows%
{
	id := windows%A_Index%
	WinGetTitle title, ahk_id %id%
	If (title = "")
{
		sumdiss:=sumdiss+1
		continue
}
Loop, parse, dismisslist, `n, `r
{
	If (title = A_LoopField)
{
		sumdiss:=sumdiss+1
		continue, 2
}
}

	WinGetClass class, ahk_id %id%
	If (class = "ApplicationFrameWindow") 
	{
		WinGetText, text, ahk_id %id%		
		If (text = "")
		{
			WinGet, style, style, ahk_id %id%
			If !(style = "0xB4CF0000")	 ; the window isn't minimized
			{
			sumdiss:=sumdiss+1
			continue
			}
		}
	}
	WinGet, style, style, ahk_id %id%
	;if !(style & 0xC00000) ; if the window doesn't have a title bar
	;{
		; If title not contains ...  ; add exceptions
			;continue
	;}

	WinGet, Path, ProcessPath, ahk_id %id%

	WinGet, exename, ProcessName , ahk_id %id%
	numofloop:=0
	loop ,%jjj%
	{
	numofloop:=numofloop+1
	if (exename=progname[numofloop])
	{
	numset:=prognum[numofloop]
	Handle := LoadPicture(Path ,"w32")
		Menu, Windows, Add, %numset%    %title%, Activate_Window
	Try 
		Menu, Windows, Icon, %numset%    %title%, HBITMAP:%handle%.,, 0
	Catch 
		Menu, Windows, Icon, %numset%    %title%, %A_WinDir%\System32\SHELL32.dll, 3, 0
	sumdiss:=sumdiss+1
	continue,2
	}
	}

if ! if_lock
{
	numleft:= A_Index - sumdiss
	numset:= num[numleft]
	Handle := LoadPicture(Path ,"w32")
		Menu, Windows, Add, %numset%    %title%, Activate_Window
	Try 
		Menu, Windows, Icon, %numset%    %title%, HBITMAP:%handle%.,, 0
	Catch 
		Menu, Windows, Icon, %numset%    %title%, %A_WinDir%\System32\SHELL32.dll, 3, 0
}else
{
	find:=0
	numofloop:=0
	loop,%locksum%
	{
	numofloop:=numofloop+1
	kkk:=locklist1[numofloop]
	if (title = kkk)
	{
	numset:=locklist2[numofloop]
	sumdiss:=sumdiss+1
	find:=1
	continue
	}
	}
	if ! find
	{
	numleft:= A_Index - sumdiss
	numset:= num2[numleft]
	}
	showlistlock .= numset "	" title "	" path "`n"
}
}
if if_lock
{
	sort, showlistlock ,F sortlines
	showlistlock := RTrim(showlistlock,"`n`r")
	Loop, Parse, showlistlock , `n, `r
{
	lll:=StrSplit(A_LoopField , A_Tab)
	title:=lll[2]
	numset:=lll[1]
	path:=lll[3]
	Handle := LoadPicture(Path ,"w32")
		Menu, Windows, Add, %numset%    %title%, Activate_Window
	Try 
		Menu, Windows, Icon, %numset%    %title%, HBITMAP:%handle%.,, 0
	Catch 
		Menu, Windows, Icon, %numset%    %title%, %A_WinDir%\System32\SHELL32.dll, 3, 0
}
}
Menu, Windows, Add, %Vswitchsame%    同程序切换, switchsame
xx:=A_ScreenWidth/2 -200
yy:=A_ScreenHeight/2 -200
return
}

switchsame:
WinActivateBottom , ahk_exe %activeexe%,,%activename%,
return

Activate_Window:
{
	liststate:=0
	Process, Close , space2enter.exe

	SetTitleMatchMode, 3
	;RegExMatch(A_ThisMenuItem, "(?<=\t).+$", title, StartingPos := 1)
	title:=SubStr(A_ThisMenuItem, 6)
	WinGetClass, Class, %title%
	If (Class="Windows.UI.Core.CoreWindow") ; the minimized window has another class 
	{
		WinActivate, %title% ahk_class ApplicationFrameWindow
		WinWaitActive, %title% ahk_class ApplicationFrameWindow
	}
	else
	{
		WinActivate, %title%
		WinWaitActive, %title%
	}
	
	if Screen_cg=1
	{
	WinGetPos, x, y, Width, Height , A
	WinGet, ifmax, MinMax , A
	ActiveMon := MWAGetMonitor(x+Width/2, y+Height/2) ; you can supply the function with x and y coordinates
	Activemouse := MWAGetMonitor()
	;msgbox The active window is on %ActiveMon% The mousecursor is on %Activemouse%
	if (ActiveMon - Activemouse != 0)
	{
	SysGet, Mon2, Monitor, %Activemouse%
	;SysGet, MonitorNamevar, MonitorName , 2
	;MsgBox, Left: %Mon2Left% -- Top: %Mon2Top% -- Right: %Mon2Right% -- Bottom %Mon2Bottom%.-- %MonitorNamevar%
	If (Class="Windows.UI.Core.CoreWindow") ; the minimized window has another class 
	{
		if ifmax = 1
		{
		WinRestore , %title% ahk_class ApplicationFrameWindow
		WinMove,%title% ahk_class ApplicationFrameWindow,,Mon2Left,Mon2Top
		WinMaximize ,%title% ahk_class ApplicationFrameWindow
		}
		else
		WinMove,%title% ahk_class ApplicationFrameWindow,,Mon2Left,Mon2Top
	}
	else
	{
		if ifmax = 1
		{
		WinRestore , %title%
		WinMove,%title%,,Mon2Left,Mon2Top
		WinMaximize ,%title%
		}
		else
		WinMove,%title%,,Mon2Left,Mon2Top
	}
	}
	}
	Screen_cg:=0
return
}

^+`::
{
if if_lock=0
{
if_lock:=1
numlist2:=numlist
locklist1:=[]
locklist2:=[]
locksum:=0

WinGet windows, List
sumdiss:=0
Loop %windows%
{
	id := windows%A_Index%
	WinGetTitle title, ahk_id %id%
	If (title = "")
{
		sumdiss:=sumdiss+1
		continue
}
Loop, parse, dismisslist, `n, `r
{
	If (title = A_LoopField)
{
		sumdiss:=sumdiss+1
		continue, 2
}
}

	WinGetClass class, ahk_id %id%
	If (class = "ApplicationFrameWindow") 
	{
		WinGetText, text, ahk_id %id%		
		If (text = "")
		{
			WinGet, style, style, ahk_id %id%
			If !(style = "0xB4CF0000")	 ; the window isn't minimized
			{
			sumdiss:=sumdiss+1
			continue
			}
		}
	}
	WinGet, style, style, ahk_id %id%
	;if !(style & 0xC00000) ; if the window doesn't have a title bar
	;{
		; If title not contains ...  ; add exceptions
			;continue
	;}
	WinGet, Path, ProcessPath, ahk_id %id%

	WinGet, exename, ProcessName , ahk_id %id%
	numofloop:=0
	loop ,%jjj%
	{
	numofloop:=numofloop+1
	if (exename=progname[numofloop])
	{
	numset:=prognum[numofloop]
	Handle := LoadPicture(Path ,"w32")
		Menu, Windows, Add, %numset%    %title%, Activate_Window
	Try 
		Menu, Windows, Icon, %numset%    %title%, HBITMAP:%handle%.,, 0
	Catch 
		Menu, Windows, Icon, %numset%    %title%, %A_WinDir%\System32\SHELL32.dll, 3, 0
	sumdiss:=sumdiss+1
	continue,2
	}
	}

	numleft:= A_Index - sumdiss
	numset:= num[numleft]
	numlist2:= StrReplace(numlist2, numset A_Space, "")
	locklist1[numleft]:=title
	locklist2[numleft]:=numset
	locksum:=locksum+1
	;IniWrite, % title, setting.ini, Lock, % numset
}
num2:=[]
num2:=StrSplit(numlist2 , A_Space)
}
else
{
if_lock:=0
;inidelete, setting.ini, Lock
}
}

sortlines(first, second)
{
x:=SubStr(first, 1,1)
y:=SubStr(second, 1,1)
x:=InStr(numlist,x)
y:=InStr(numlist,y)
return (x - y)
}
return

goguding:
run addons\添加固定搭配.ahk
ExitApp
gopaichu:
run addons\添加排除列表.ahk
ExitApp

relo:
reload

Exit:
ExitApp

hotkey1change:
{
Gui hotkey1set: Add, Edit, r9 vhotkey1 w135, % hotkey1
Gui hotkey1set: Add, button, Default w130 ghotkey1set, OK
Gui hotkey1set: show

return
}
hotkey1set:
{
Gui hotkey1set: Submit
IniWrite,% hotkey1, setting.ini, hotkey1, hotkey1
reload
}

hotkey2change:
{
Gui hotkey2set: Add, Edit, r9 vhotkey2 w135, % hotkey2
Gui hotkey2set: Add, button, Default w130 ghotkey2set, OK
Gui hotkey2set: show

return
}
hotkey2set:
{
Gui hotkey2set: Submit
IniWrite,% hotkey2, setting.ini, hotkey2, hotkey2
reload
}

hotkey3change:
{
Gui hotkey3set: Add, Edit, r9 vhotkey3 w135, % hotkey3
Gui hotkey3set: Add, button, Default w130 ghotkey3set, OK
Gui hotkey3set: show

return
}
hotkey3set:
{
Gui hotkey3set: Submit
IniWrite,% hotkey3, setting.ini, hotkey3, hotkey3
reload
}

MWAGetMonitor(Mx := "", My := "")
{
	if  (!Mx or !My) 
	{
		; if Mx or My is empty, revert to the mouse cursor placement
		Coordmode, Mouse, Screen	; use Screen, so we can compare the coords with the sysget information`
		MouseGetPos, Mx, My
	}

	SysGet, MonitorCount, 80	; monitorcount, so we know how many monitors there are, and the number of loops we need to do
	Loop, %MonitorCount%
	{
		SysGet, mon%A_Index%, Monitor, %A_Index%	; "Monitor" will get the total desktop space of the monitor, including taskbars

		if ( Mx >= mon%A_Index%left ) && ( Mx < mon%A_Index%right ) && ( My >= mon%A_Index%top ) && ( My < mon%A_Index%bottom )
		{
			ActiveMon := A_Index
			break
		}
	}
	return ActiveMon
}

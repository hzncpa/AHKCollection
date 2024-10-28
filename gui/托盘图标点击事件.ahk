#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

OnMessage(0x404, "AHK_NOTIFYICON")


AHK_NOTIFYICON(wParam, lParam, uMsg, hWnd)
{
	;;脚本托盘图标单击与双击尽量不要同时启用
	if (lParam = 0x201){  ;鼠标左键单击脚本托盘图标
		MsgBox,你单击了鼠标左键
	}
	if (lParam = 0x203){  ;鼠标左键双击脚本托盘图标
		MsgBox,你双击了鼠标左键
	}
	if (lParam = 0x204){  ;鼠标右键单击脚本托盘图标
		MsgBox,你单击了鼠标右键
	}
	if (lParam = 0x206){  ;鼠标右键双击脚本托盘图标
		MsgBox,你双击了鼠标右键
	}
	if (lParam = 0x207){  ;鼠标中键单击脚本托盘图标
		MsgBox,你单击了鼠标中键
	}
	if (lParam = 0x209){  ;鼠标中键双击脚本托盘图标
		MsgBox,你双击了鼠标中键
	}
}

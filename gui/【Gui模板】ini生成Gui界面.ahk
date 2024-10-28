#NoEnv
SetBatchLines -1
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

SplitPath, A_ScriptFullPath, , , , 脚本名无后缀

; 日常标准的ini读取配置测试
/*
if !FileExist(A_ScriptDir "\" 脚本名无后缀 ".ini") {
_=
(
[决斗]
角色移动=1
学院=0
金币上限=0
斗币上限=1
调试=1

[答题]
答题纠错=1
纠错时间=10
集结等待=1
等待时间=4
社团徽章=1
社团贡献=0
魔法史=0
魔法史开箱=1
开箱轮数=8
调试=1
延时=0
调查=4

[全局设置]
开机启动【勾选】=0
启动延时=5
启动弹窗=1
快捷键=F1
启动流程=2
停止条件=1
iOS推送=0
iOS推送SCKEY=
)
FileAppend, %_%, % A_ScriptDir "\" 脚本名无后缀 ".ini"
}
*/

; 定制加强的ini配置测试
if !FileExist(A_ScriptDir "\" 脚本名无后缀 ".ini") {
_=
(
[决斗]
允许角色随机移动【勾选】=1
在晚上 19 点钟后，自动进入学院活动【勾选】=0
1【换行】=
　停止自动决斗的条件：【文本】=
当 "金币" 到上限时停止【勾选】=1
当 "斗币" 到上限时停止【勾选】=0
2【换行】=
显示调试信息【勾选】=0

[答题]
开关答题纠错功能【勾选】=1
　在几秒后，使用人数统计答案纠错【30】=5
开关集结等待功能【勾选】=1
　在几分钟集结后，仍然不开始就退出此房间【30】=4
1【换行】=
　停止自动答题的条件：【文本】=
当 "社团徽章" 到上限时停止【勾选】=1
当 "社团贡献" 到上限时停止【勾选】=0
2【换行】=
切换 "魔法史+麻瓜" 答题【勾选】=0
开关魔法史开箱功能【勾选】=1
　在第几轮答题后，启用开箱子【30】=8
3【换行】=
显示调试信息【勾选】=0

[全局设置]
开机启动【勾选】=0
　开机延时几秒后启动脚本【30】=5
启动时弹出设置界面【勾选】=1
1【换行】=
快捷键设置：【热键】=F1
应用【按钮1】=AHKiniGui关闭脚本
快捷键触发编号介绍 -【文本】=1：决斗、2：答题、3：调查
　按下快捷键启动流程【30】=1
2【换行】=
自动化中止以下介绍 -【文本】=1：仅提示、2：提示+声音、3：电脑关机
　自动化的停止条件【30】=3
3【换行】=
iOS推送SCKEY【260】=https://api.day.app/111111111/测试
)
FileAppend, %_%, % A_ScriptDir "\" 脚本名无后缀 ".ini"
}

ini生成Gui显示()

; ahk自带ini读写命令测试
; iniRead, ini读取到变量, %A_ScriptDir%\%脚本名无后缀%.ini, 全局设置, 开机启动【勾选】
; MsgBox % "ini读取到的键值：" ini读取到变量 "`n`nEasyini的等效读取写法：" AHKini["全局设置", "开机启动【勾选】"]
Return

ini生成Gui显示(ini路径:=1, 显示界面:=1, 托盘菜单:=1) {
	Static
	if (ini路径=1) {
		SplitPath, A_ScriptFullPath, , , , 脚本名无后缀
		ini路径 := A_ScriptDir "\" 脚本名无后缀 ".ini"
	}

	Global AHKini := New Easyini(ini路径)  ; 用Easyini库读取ini文件
	读取所有段名 := StrSplit(AHKini.GetSections(), "`n")

	SplitPath, ini路径, , , , 脚本名无后缀

	Gui _Gui_ini: Destroy

	; 先备份Gui主窗口的句柄
	Global inigui_id  ; 仅方便函数外部判断iniGui主窗口是否存在
	Gui _Gui_ini: +Hwndinigui_id  ; +AlwaysOnTop
	Gui _Gui_ini: Margin, 15, 15

	Gui _Gui_ini: Add, Tab3, w440, % 所有段名划分 := AHKini.GetSections("|")
	_v变量编号 := 0
	, Gui变量对应ini字典 := {}
	For k, v in StrSplit(所有段名划分, "|")
	{
		Gui _Gui_ini: Tab, %k%
		; 添加一个文本控件作为父控件，获取父控件句柄
		Gui _Gui_ini: Add, Text, Hwndparent_id w400 h220

		; 新建一个Gui子窗口，获取子窗口句柄
		Gui, New, +Hwndsub_id -DPIScale
		Gui, Color, FFFFFF

		所有键名分割 := StrSplit(AHKini.GetKeys(读取所有段名[k]), "`n")
		Loop % 所有键名分割.Length() {
			if (A_Index>1)
				Try Gui Add, Text, % "w-2 h-2 xs y+" 7*A_ScreenDPI/96  ; 这句当Gui换行用
			_键值内容 := AHKini[读取所有段名[k], 所有键名分割[A_Index]]
			, 键名【】外内容 := RegExReplace(所有键名分割[A_Index], "【[^【】]*】$")
			, 提取【】内 := RegExReplace(所有键名分割[A_Index], "^.+【([^】]+)】$", "$1")  ; 用键名最后【】包裹来定义参数排版与生成
			if InStr(提取【】内, "勾选") {
				Try Gui Add, CheckBox, % (提取【】内="勾选跟随" ? "ys" : "Section x8") " h14 viniTempVar" ++_v变量编号 " gAHKiniGuiRunButton Checked" _键值内容, %键名【】外内容%
				Gui变量对应ini字典[_v变量编号] := v "ξ" 所有键名分割[A_Index]
			} else if (提取【】内="文本") {
				Try Gui Add, Text, Section x8, %键名【】外内容%
				Try Gui Add, Text, x+4 ys, %_键值内容%
			} else if (提取【】内="换行") {
				Try Gui Add, Text, Section x8
			} else if (提取【】内="热键") {
				Try Gui Add, Text, Section x8, %键名【】外内容%
				Try Gui Add, Hotkey, % "x+4 ys-4 w" 70*A_ScreenDPI/96 " gAHKiniGuiRunButton viniTempVar" ++_v变量编号
				Try GuiControl, , iniTempVar%_v变量编号%, %_键值内容%
				Gui变量对应ini字典[_v变量编号] := v "ξ" 所有键名分割[A_Index]
			} else if InStr(提取【】内, "按钮") {  ; 当【】包含"按钮"时触发，还可以进一步用分割符添加Gui坐标参数等
				if IsLabel(_键值内容)
					Try Gui Add, Button, ys-5 g%_键值内容%, %键名【】外内容%  ; 需要换行或参数可自行定制
			} else {  ; 未用【】标注的，都以 文本+补齐+编辑框 显示
				_ := RegExReplace(提取【】内, "\D")
				if (RegExMatch(键名【】外内容, "m)(*ANYCRLF)[\x{4e00}-\x{9fa5}]+", 0, 1)=0)  ; 判断有没有汉字
					Try Gui Add, Text, Section x8, % 键名【】外内容 "：" (_="" ? ( StrLen(键名【】外内容)>13 ? "	" : (StrLen(键名【】外内容)<6 ? "			" : "		")) : "")  ; 英文 对齐判断
				 else
					Try Gui Add, Text, Section x8, % 键名【】外内容 "：" (_="" ? (StrLen(键名【】外内容)>2 ? "	" : "		") : "")  ; 汉字 对齐判断
				Try Gui Add, Edit, % "gAHKiniGuiRunButton viniTempVar" ++_v变量编号 " x+4 ys-4 w" (_="" ? 50 : _)*A_ScreenDPI/96, %_键值内容%
				Gui变量对应ini字典[_v变量编号] := v "ξ" 所有键名分割[A_Index]
			}
		}

		; 利用ScrollBind类，将Gui子窗口绑定到父控件中
		ScrollBind.Bind(parent_id, sub_id, (所有键名分割.Length()<9 ? 0 : 1))  ; 显示超过9条时，启动滚动功能

		; 利用Gui主窗口的句柄返回默认的Gui
		Gui %inigui_id%: Default
	}
	Gui _Gui_ini: Tab

	if (显示界面=1)
		Gui _Gui_ini: Show, Center, % " " 脚本名无后缀 ".ini  配置界面"

	if (托盘菜单=1) {
		Menu Tray, NoStandard
		AHKiniGui注册 := Func("ini生成Gui显示").Bind(1, 1)
		Menu Tray, Add, 设置脚本(&S), %AHKiniGui注册%
		Menu Tray, Icon, 设置脚本(&S), shell32.dll, 91, 16
		Menu Tray, Add
		Menu Tray, Add, 重启脚本(&R), AHKiniGui重启脚本
		Menu Tray, Icon, 重启脚本(&R), shell32.dll, % (A_OSVersion="WIN_XP") ? 45 : 239, 16
		Menu Tray, Add
		Menu Tray, Add, 关闭脚本(&X), AHKiniGui关闭脚本
		Menu Tray, Icon, 关闭脚本(&X), shell32.dll, 132, 16
		Menu Tray, Color, FFFFFF
		Menu Tray, Default, 设置脚本(&S)
	}
	Return

	AHKiniGuiRunButton:
		GuiControlGet, _焦点控件名称_, Focus
		GuiControlGet, _控件id_, Hwnd, %_焦点控件名称_%
		GuiControlGet, _焦点控件内容_, , %_控件id_%
		GuiControlGet, _v变量名称_, FocusV
		_字典v变量内容拆分_ := StrSplit(Gui变量对应ini字典[RegExReplace(_v变量名称_, "\D")], "ξ")  ; 用 ξ 做分割符
		, AHKini[_字典v变量内容拆分_[1], _字典v变量内容拆分_[2]] := _焦点控件内容_
		, AHKini.Save()
	Return

	AHKiniGui重启脚本:
		Reload
	Return
	; _Gui_iniGuiClose:
	AHKiniGui关闭脚本:
		ExitApp
	Return
}

Class ScrollBind {
	__New(args*) {
		return this.base
	}

	Bind(parent_id, sub_id, 启用滚动页面:=1) {
		static init:=0
		if 启用滚动页面=0
			this.排除滚动页面 .= sub_id+0 "`n"
		if !DllCall("IsWindow", "Ptr",parent_id) or !DllCall("IsWindow", "Ptr",sub_id)
			return
		if !init
			init:=1, this.Scroll_ID:=[]
			, OnMessage(WM_MOUSEWHEEL:=0x20A, this.WM_MOUSEWHEEL.Bind(this))
			, OnMessage(WM_VSCROLL:=0x115, this.WM_VSCROLL.Bind(this))
			, OnMessage(WM_HSCROLL:=0x114, this.WM_VSCROLL.Bind(this))

		Critical, % ("", bak:=A_IsCritical)
		VarSetCapacity(rect,16)
		, DllCall("GetClientRect", "Ptr",parent_id, "Ptr",&rect)
		, w:=NumGet(rect, 8, "Int"), h:=NumGet(rect, 12, "Int")
		Gui, %sub_id%: +Parent%parent_id% -Caption +ToolWindow -Border
		Gui, %sub_id%: Show, NA x0 y0 w%w% h%h%
		this.UpdateScrollBars(sub_id, w, h)
		, this.Scroll_ID[parent_id]:=sub_id
		, this.Scroll_ID[sub_id]:=sub_id
		Critical, %bak%
	}

	ReSize(sub_id, w, h) {
		DllCall("MoveWindow","Ptr",sub_id,"int",0,"int",0,"int",w,"int",h,"int",1)
		, this.UpdateScrollBars(sub_id, w, h)
	}

	WM_MOUSEWHEEL(wParam) {
		Critical
		if (InStr(this.排除滚动页面, A_Gui+0)=0) and (A_Gui!=1) {
			if (A_Gui="")
				return
			MouseGetPos,,,, id, 2
			if (this.Scroll_ID[id]) or (this.Scroll_ID[id:=DllCall("GetParent","ptr",id)]) or (this.Scroll_ID[id:=DllCall("GetParent","ptr",id)])
			{
				id:=this.Scroll_ID[id], wParam:=(wParam>>16&0xFFFF)>0x7FFF
				Loop 4
					this.WM_VSCROLL(wParam, 0, 0x115, id)
				return 1
			}
		}
	}

	UpdateScrollBars(GuiHwnd, GuiWidth, GuiHeight) {
		static SIF_RANGE:=1, SIF_PAGE:=2, SB_HORZ:=0, SB_VERT:=1
		if (GuiWidth<0 or GuiHeight<0)
			return
		DetectHiddenWindows, % (bak:=A_DetectHiddenWindows)?"On":"On"
		WinGet, List, ControlListHwnd, ahk_id %GuiHwnd%
		DetectHiddenWindows, %bak%
		Left:=Top:=9999, Right:=Bottom:=0
		Loop, Parse, List, `n
		{
			GuiControlGet, c, Pos, %A_LoopField%
			Left:=Min(Left, cX), Top:=Min(Top, cY)
			Right:=Max(Right, cX+cW), Bottom:=Max(Bottom, cY+cH)
		}
		Left-=8, Top-=8, Right+=8, Bottom+=8
		ScrollWidth:=Right-Left, ScrollHeight:=Bottom-Top
		, VarSetCapacity(si, 28, 0)
		, NumPut(28, si)
		, NumPut(SIF_RANGE | SIF_PAGE, si, 4)
		, NumPut(ScrollWidth, si, 12)
		, NumPut(GuiWidth, si, 16)
		, DllCall("SetScrollInfo", "Ptr",GuiHwnd, "uint",SB_HORZ, "Ptr",&si, "int",1)
		, NumPut(ScrollHeight, si, 12)
		, NumPut(GuiHeight, si, 16)
		, DllCall("SetScrollInfo", "Ptr",GuiHwnd, "uint",SB_VERT, "Ptr",&si, "int",1)
		, x:=(Left<0 && Right<GuiWidth) ? Min(-Left, GuiWidth-Right) : 0
		, y:=(Top<0 && Bottom<GuiHeight) ? Min(-Top, GuiHeight-Bottom) : 0
		if (x || y)
			DllCall("ScrollWindow", "Ptr",GuiHwnd, "int",x, "int",y, "int",0, "int",0)
	}

	WM_VSCROLL(wParam, lParam, msg, hwnd) {
		static SIF_ALL:=0x17, SCROLL_STEP:=10
		Critical
		bar:=(msg=0x115)
		, VarSetCapacity(si, 28, 0), NumPut(28, si, "UInt")
		, NumPut(SIF_ALL, si, 4, "UInt")
		if !DllCall("GetScrollInfo", "Ptr",hwnd, "Int",bar, "Ptr",&si)
			return
		VarSetCapacity(rect,16), DllCall("GetClientRect", "Ptr",hwnd, "Ptr",&rect)
		, h:=bar ? NumGet(rect, 12, "Int") : NumGet(rect, 8, "Int")
		, new_pos:=old_pos:=NumGet(si, 20, "UInt")
		Switch (wParam & 0xFFFF)
		{
			Case 0:	new_pos-=SCROLL_STEP
			Case 1:	new_pos+=SCROLL_STEP
			Case 2:	new_pos-=h-SCROLL_STEP
			Case 3:	new_pos+=h-SCROLL_STEP
			Case 4, 5: new_pos:=wParam>>16
			Case 6:	new_pos:=NumGet(si, 8, "Int")
			Case 7:	new_pos:=NumGet(si, 12, "Int")
			Default:  return
		}
		min:=NumGet(si, 8, "Int")
		, max:=NumGet(si, 12, "Int") - NumGet(si, 16, "UInt")
		, new_pos:=Min(Max(min, new_pos), max)
		, (bar) ? (x:=0, y:=old_pos-new_pos) : (x:=old_pos-new_pos, y:=0)
		, DllCall("ScrollWindow", "Ptr",hwnd, "Int",x, "Int",y, "Int",0, "Int",0)
		, NumPut(new_pos, si, 20, "Int")
		, DllCall("SetScrollInfo", "Ptr",hwnd, "Int",bar, "Ptr",&si, "Int",1)
	}

}


class_EasyIni(sFile="", sLoadFromStr="") {
	return new EasyIni(sFile, sLoadFromStr)
}

class EasyIni {
	__New(sFile="", sLoadFromStr="") {
		this := this.CreateIniObj("EasyIni_ReservedFor_m_sFile", sFile
			, "EasyIni_ReservedFor_TopComments", Object())

		if (sFile == A_Blank && sLoadFromStr == A_Blank)
			return this

		if (SubStr(sFile, StrLen(sFile)-3, 4) != ".ini")
			this.EasyIni_ReservedFor_m_sFile := sFile := (sFile . ".ini")

		sIni = %sLoadFromStr%
		if (sIni == A_Blank)
			FileRead, sIni, %sFile%

		Loop, Parse, sIni, `n, `r
		{
			sTrimmedLine := Trim(A_LoopField)
			if (SubStr(sTrimmedLine, 1, 1) == ";" || sTrimmedLine == A_Blank)
			{
				LoopField := A_LoopField == A_Blank ? Chr(14) : A_LoopField

				if (sCurSec == A_Blank)
					this.EasyIni_ReservedFor_TopComments.Insert(A_Index, LoopField)
				else {
					if (sPrevKeyForThisSec == A_Blank)
						sPrevKeyForThisSec := "SectionComment"

					if (IsObject(this[sCurSec].EasyIni_ReservedFor_Comments)) {
						if (this[sCurSec].EasyIni_ReservedFor_Comments.HasKey(sPrevKeyForThisSec))
							this[sCurSec].EasyIni_ReservedFor_Comments[sPrevKeyForThisSec] .= "`n" LoopField
						else this[sCurSec].EasyIni_ReservedFor_Comments.Insert(sPrevKeyForThisSec, LoopField)
					} else {
						if (IsObject(this[sCurSec]))
							this[sCurSec].EasyIni_ReservedFor_Comments := {(sPrevKeyForThisSec):LoopField}
						else this[sCurSec, "EasyIni_ReservedFor_Comments"] := {(sPrevKeyForThisSec):LoopField}
					}
				}
				continue
			}

			if (SubStr(sTrimmedLine, 1, 1) = "[" && InStr(sTrimmedLine, "]")) {
				if (sCurSec != A_Blank && !this.HasKey(sCurSec))
					this[sCurSec] := EasyIni_CreateBaseObj()
				sCurSec := SubStr(sTrimmedLine, 2, InStr(sTrimmedLine, "]", false, 0) - 2)
				, sPrevKeyForThisSec := ""
				continue
			}

			iPosOfEquals := InStr(sTrimmedLine, "=")
			if (iPosOfEquals) {
				sPrevKeyForThisSec := SubStr(sTrimmedLine, 1, iPosOfEquals - 1)
				, val := SubStr(sTrimmedLine, iPosOfEquals + 1)
				StringReplace, val, val , `%A_ScriptDir`%, %A_ScriptDir%, All
				StringReplace, val, val , `%A_WorkingDir`%, %A_ScriptDir%, All
				this[sCurSec, sPrevKeyForThisSec] := val
			} else
				sPrevKeyForThisSec := sTrimmedLine
				, this[sCurSec, sPrevKeyForThisSec] := ""

		}

		if (sCurSec != A_Blank && !this.HasKey(sCurSec))
			this[sCurSec] := EasyIni_CreateBaseObj()

		return this
	}

	CreateIniObj(parms*) {
		static base := {__Set: "EasyIni_Set", _NewEnum: "EasyIni_NewEnum", Delete: "Delete", Remove: "EasyIni_Remove", Insert: "EasyIni_Insert", InsertBefore: "EasyIni_InsertBefore", AddSection: "EasyIni.AddSection", RenameSection: "EasyIni.RenameSection", DeleteSection: "EasyIni.DeleteSection", GetSections: "EasyIni.GetSections", FindSecs: "EasyIni.FindSecs", AddKey: "EasyIni.AddKey", RenameKey: "EasyIni.RenameKey", DeleteKey: "EasyIni.DeleteKey", RemoveKey: "EasyIni.RemoveKey", GetKeys: "EasyIni.GetKeys", FindKeys: "EasyIni.FindKeys", GetVals: "EasyIni.GetVals", FindVals: "EasyIni.FindVals", HasVal: "EasyIni.HasVal", SetKeyVal: "EasyIni.SetKeyVal", GetCommentContent: "EasyIni.GetCommentContent", GetTopComments: "EasyIni.GetTopComments", GetSectionComments: "EasyIni.GetSectionComments", GetKeyComments: "EasyIni.GetKeyComments", AddComment: "EasyIni.AddComment", AddTopComment: "EasyIni.AddTopComment", AddSectionComment: "EasyIni.AddSectionComment", AddKeyComment: "EasyIni.AddKeyComment", DeleteComment: "EasyIni.DeleteComment", Update: "EasyIni.Update", Compare: "EasyIni.Compare", Copy: "EasyIni.Copy", Merge: "EasyIni.Merge", GetFileName: "EasyIni.GetFileName", GetOnlyIniFileName:"EasyIni.GetOnlyIniFileName", IsEmpty:"EasyIni.IsEmpty", Reload: "EasyIni.Reload", GetIsSaved: "EasyIni.GetIsSaved", Save: "EasyIni.Save", ToVar: "EasyIni.ToVar", GetValue: "EasyIni.GetValue"}
		return Object("_keys", Object(), "base", base, parms*)
	}

	AddSection(sec, key="", val="", ByRef rsError="") {
		if (this.HasKey(sec)) {
			MsgBox % rsError := "Error! Cannot add new section [" sec "], because it already exists."
			return false
		}

		if (key == A_Blank)
			this[sec] := EasyIni_CreateBaseObj()
		else this[sec, key] := val

		return true
	}

	RenameSection(sOldSec, sNewSec, ByRef rsError="") {
		if (!this.HasKey(sOldSec)) {
			MsgBox % rsError := "Error! Could not rename section [" sOldSec "], because it does not exist."
			return false
		}
		if (sOldSec = sNewSec)
			return true

		this[sNewSec] := this[sOldSec]
		, this.DeleteSection(sOldSec)
		return true
	}

	DeleteSection(sec) {
		r := this.Remove(sec)
		return r
	}

	GetSections(sDelim="`n", sSort="") {
		for sec in this
			secs .= (A_Index == 1 ? sec : sDelim sec)

		if (sSort)
			Sort, secs, D%sDelim% %sSort%

		return secs
	}

	FindSecs(sExp, iMaxSecs="") {
		aSecs := []
		for sec in this {
			if (RegExMatch(sec, sExp)) {
				aSecs.Insert(sec)
				if (iMaxSecs&& aSecs.MaxIndex() == iMaxSecs)
					return aSecs
			}
		}
		return aSecs
	}

	AddKey(sec, key, val="", ByRef rsError="") {
		if (this.HasKey(sec)) {
			if (this[sec].HasKey(key)) {
				MsgBox % rsError := "Error! Could not add key, " key " because there is a key in the same section:`nSection: " sec "`nKey: " key
				return false
			}
		} else {
			MsgBox % rsError := "Error! Could not add key, " key " because Section, " sec " does not exist."
			return false
		}
		this[sec, key] := val
		return true
	}

	RenameKey(sec, OldKey, NewKey, ByRef rsError="") {
		if (!this[sec].HasKey(OldKey)) {
			MsgBox % rsError := "Error! The specified key " OldKey " could not be modified because it does not exist."
			return false
		}

		ValCopy := this[sec][OldKey]
		, CommentCopy := this.GetKeyComments(sec, OldKey)
		, this.RemoveKey(sec, OldKey)
		, this.AddKey(sec, NewKey)
		if (!IsStringEmpty(CommentCopy))
			this.AddKeyComment(sec, NewKey, CommentCopy)
		this[sec][NewKey] := ValCopy
		return true
	}

	DeleteKey(sec, key) {
		this[sec].Delete(key)
		return
	}

	RemoveKey(sec, key) {
		this[sec].Remove(key)
		return
	}

	GetKeys(sec, sDelim="`n", sSort="") {
		for key in this[sec]
			keys .= A_Index == 1 ? key : sDelim key

		if (sSort)
			Sort, keys, D%sDelim% %sSort%
		return keys
	}

	FindKeys(sec, sExp, iMaxKeys="") {
		aKeys := []
		for key in this[sec] {
			if (RegExMatch(key, sExp)) {
				aKeys.Insert(key)
				if (iMaxKeys && aKeys.MaxIndex() == iMaxKeys)
					return aKeys
			}
		}
		return aKeys
	}

	FindExactKeys(key, iMaxKeys="") {
		aKeys := {}
		for sec, aData in this {
			if (aData.HasKey(key)) {
				aKeys.Insert(sec, key)
				if (iMaxKeys && aKeys.MaxIndex() == iMaxKeys)
					return aKeys
			}
		}
		return aKeys
	}

	GetVals(sec, sDelim="`n", sSort="") {
		for key, val in this[sec]
			vals .= A_Index == 1 ? val : sDelim val

		if (sSort)
			Sort, vals, D%sDelim% %sSort%
		return vals
	}

	FindVals(sec, sExp, iMaxVals="") {
		aVals := []
		for key, val in this[sec] {
			if (RegExMatch(val, sExp)) {
				aVals.Insert(val)
				if (iMaxVals && aVals.MaxIndex() == iMaxVals)
					break
			}
		}
		return aVals
	}

	HasVal(sec, FindVal) {
		for k, val in this[sec]
			if (FindVal = val)
				return true
		return false
	}

	SetKeyVal(sec, key, val, ByRef rsError="") {
		if (!this.HasKey(sec)) {
			MsgBox % rsError := "Error! Could not set value '" val "' for key '" key "' because Section [" sec "] does not exist."
			return false
		}
		if (!this[sec].HasKey(key)) {
			MsgBox % rsError := "Error! Could not set value '" val "' for key '" key "' because key does not exist in Section [" sec "]."
			return false
		}
		this[sec, key] := val
		return true
	}

	GetCommentContent(sec="", key="", topComment=false) {
		if (topComment) 
			commentsObj := this.EasyIni_ReservedFor_TopComments
		else
			commentsObj := StrSplit(this[sec].EasyIni_ReservedFor_Comments[key], "`n")

		for commentIndex, commentContent in commentsObj
			if (!IsStringEmpty(commentContent))
				sComments .= commentContent "`n"

		return sComments
	}

	GetTopComments() {
		return this.GetCommentContent( , , true)
	}

	GetSectionComments(sec) {
		return this.GetCommentContent(sec, "SectionComment")
	}

	GetKeyComments(sec, key) {
		return this.GetCommentContent(sec, key)
	}

	AddComment(sec="", key="", comment="", topComment=false, ByRef rsError="") {
		for commentIndex, commentContent in StrSplit(comment, "`n") {
			if (!IsStringEmpty(commentContent)) {
				if (InStr(commentContent, ";") != 1)
					commentContent := "; " commentContent

				if (topComment) {
					if (!this.HasKey("EasyIni_ReservedFor_TopComments"))
						this.Insert("EasyIni_ReservedFor_TopComments", [])

					this.EasyIni_ReservedFor_TopComments.Insert(commentContent)
				} else {
					if (!this.HasKey(sec)) {
						if (key == "SectionComment")
							rsError := "Error! Could not add comment to Section [" sec "] because it does not exist."
						else 
							rsError := "Error! Could not add comment to key '" key "' because Section [" sec "] does not exist."
						MsgBox %rsError%
						return false
					}
					if (key != "SectionComment" and !this[sec].HasKey(key)) {
						MsgBox % rsError := "Error! Could not add comment to key '" key "' because this key does not exist in Section [" sec "]."
						return false
					}
					if (!IsObject(this[sec].EasyIni_ReservedFor_Comments))
						this[sec].EasyIni_ReservedFor_Comments := {}

					commentCurrent := this[sec].EasyIni_ReservedFor_Comments[key]
					if (IsStringEmpty(commentCurrent))
						this[sec].EasyIni_ReservedFor_Comments.Insert(key, commentContent)
					else
						this[sec].EasyIni_ReservedFor_Comments.Insert(key, commentCurrent "`n" commentContent)
				}
			}
		}
		return true
	}

	AddTopComment(comment, ByRef rsError="") {
		return this.AddComment( , , comment, true, rsError)
	}

	AddSectionComment(sec, comment, ByRef rsError="") {
		return this.AddComment(sec, "SectionComment", comment, , rsError)
	}

	AddKeyComment(sec, key, comment, ByRef rsError="") {
		return this.AddComment(sec, key, comment, , rsError)
	}

	DeleteComment(sec="", key="", comment="", topComment=false, ByRef rsError="") {
		for commentIndex, commentContent in StrSplit(comment, "`n") {
			if (!IsStringEmpty(commentContent)) {
				if (topComment) {
					for commentIndexTop, commentContentTop in this.EasyIni_ReservedFor_TopComments
						if (commentContentTop ~= commentContent)
							this.EasyIni_ReservedFor_TopComments.Delete(commentIndexTop)
				} else {
					if (!this.HasKey(sec)) {
						if (key == "SectionComment")
							rsError := "Error! Could not delete comment from Section [" sec "] because it does not exist."
						 else
							rsError := "Error! Could not remove comment from key '" key "' because Section [" sec "] does not exist."
						MsgBox %rsError%
						return false
					} else {
						if (key != "SectionComment" and !this[sec].HasKey(key)) {
							MsgBox % rsError := "Error! Could not delete comment from key '" key "' because this key does not exist in Section [" sec "]."
							return false
						}
						for commentIndexCurrent, commentContentCurrent in StrSplit(this[sec].EasyIni_ReservedFor_Comments[key], "`n") {
							if (commentContentCurrent ~= commentContent)
								continue
							 else
								commentCurrentStr .= commentContentCurrent "`n"
						}
						if (!IsStringEmpty(commentCurrentStr))
							this[sec].EasyIni_ReservedFor_Comments.Insert(key, commentCurrentStr)
						else
							this[sec].EasyIni_ReservedFor_Comments.Delete(key)
					}
				}
			}
		}
		return true
	}

	DeleteTopComment(comment, ByRef rsError="") {
		return this.DeleteComment( , , comment, true, rsError)
	}

	DeleteSectionComment(sec, comment, ByRef rsError="") {
		return this.DeleteComment(sec, "SectionComment", comment, , rsError)
	}

	DeleteKeyComment(sec, key, comment, ByRef rsError="") {
		return this.DeleteComment(sec, key, comment, , rsError)
	}

	Update(SourceIni, sections=true, keys=true, values=false, top_comments=false, section_comments=true, key_comments=true, repeatedRecursions=0) {
		if (!IsObject(SourceIni))
			SourceIni := class_EasyIni(SourceIni)

		if (SourceIni.IsEmpty())
			return

		if (top_comments) {
			for commentIndex, commentContent in StrSplit(SourceIni.GetTopComments(), "`n")
				if (!InStr(this.GetTopComments(), commentContent))
					this.AddTopComment(commentContent)
		}
		for sectionName, sectionKeys in SourceIni {
			if (sections and !this.HasKey(sectionName))
				this.AddSection(sectionName)

			if (section_comments and this.HasKey(sectionName)) {
				for commentIndex, commentContent in StrSplit(SourceIni.GetSectionComments(sectionName), "`n")
					if (!InStr(this.GetSectionComments(sectionName), commentContent))
						this.AddSectionComment(sectionName, commentContent)
			}
			for keyName, keyVal in sectionKeys {
				if (keys and !this[sectionName].HasKey(keyName))
					this.AddKey(sectionName, keyName, keyVal)

				if (this[sectionName].HasKey(keyName)) {
					if (values)
						this.SetKeyVal(sectionName, keyName, keyVal)

					if (key_comments) {
						for commentIndex, commentContent in StrSplit(SourceIni.GetKeyComments(sectionName, keyName), "`n")
							if (!InStr(this.GetKeyComments(sectionName, keyName), commentContent))
								this.AddKeyComment(sectionName, keyName, commentContent)
					}
				}
			}
		}

		if (top_comments) {
			for commentIndex, commentContent in StrSplit(this.GetTopComments(), "`n") {
				if (!InStr(SourceIni.GetTopComments(), commentContent)) {
					this.DeleteTopComment(commentContent)
				}
			}
		}

		removeSectionsList := []
		for sectionName, sectionKeys in this {
			if (sections and !SourceIni.HasKey(sectionName))
				removeSectionsList.push(sectionName)

			if (section_comments and SourceIni.HasKey(sectionName)) {
				for commentIndex, commentContent in StrSplit(this.GetSectionComments(sectionName), "`n")
					if (!InStr(SourceIni.GetSectionComments(sectionName), commentContent))
						this.DeleteSection(sectionName, commentContent)
			}
			for keyName, keyVal in sectionKeys {
				if (keys and !SourceIni[sectionName].HasKey(keyName))
					this.RemoveKey(sectionName, keyName)

				if (key_comments and SourceIni[sectionName].HasKey(keyName)) {
					for commentIndex, commentContent in StrSplit(this.GetKeyComments(sectionName, keyName), "`n")
						if (!InStr(SourceIni.GetKeyComments(sectionName, keyName), commentContent))
							this.DeleteKeyComment(sectionName, keyName, commentContent)
				}
			}
		}

		Loop, % removeSectionsList.MaxIndex()
			this.DeleteSection(removeSectionsList[A_Index])
		return
	}

	Compare(SourceIni, sections=true, keys=true, values=false, comments=false) {
		if (!IsObject(SourceIni))
			SourceIni := class_EasyIni(SourceIni)

		if (sections)
			if (this.GetSections("|", "C") != SourceIni.GetSections("|", "C"))
				return false

		if (keys)
			for sectionIndex, sectionName in StrSplit(this.GetSections("|", "C"), "|")
				if (this.GetKeys(sectionName, "|", "C") != SourceIni.GetKeys(sectionName, "|", "C"))
					return false

		if (comments) {
			for commentIndex, commentContent in this.EasyIni_ReservedFor_TopComments {
				sTopComments .= (A_Index == 1) ? commentContent : "|" commentContent
				Sort, sTopComments, "|" "C"
			}
			for commentIndex, commentContent in SourceIni.EasyIni_ReservedFor_TopComments {
				sTopCommentsSource .= (A_Index == 1) ? commentContent : "|" commentContent
				Sort, sTopCommentsSource, "|" "C"
			}
			if (sTopComments != sTopCommentsSource)
				return false

			for sectionIndex, sectionName in StrSplit(this.GetSections("|", "C"), "|") {
				for commentKey, commentContent in this[sectionName].EasyIni_ReservedFor_Comments {
					sAllSectionComments .= (A_Index == 1) ? commentContent : "|" commentContent
					Sort, sAllSectionComments, "|" "C"
				}
				for commentKey, commentContent in SourceIni[sectionName].EasyIni_ReservedFor_Comments {
					sAllSectionCommentsSource .= (A_Index == 1) ? commentContent : "|" commentContent
					Sort, sAllSectionCommentsSource, "|" "C"
				}
				if (sAllSectionComments != sAllSectionCommentsSource)
					return false
			}
		}
		return true
	}

	Copy(SourceIni, bCopyFileName = true) {
		if (IsObject(SourceIni))
			sIniString := SourceIni.ToVar()
		 else FileRead, sIniString, %SourceIni%

		if (IsObject(this)) {
			if (bCopyFileName)
				sOldFileName := this.GetFileName()
			this := A_Blank

			, this := class_EasyIni(SourceIni.GetFileName(), sIniString)

			, this.EasyIni_ReservedFor_m_sFile := sOldFileName
		} else
			return class_EasyIni(bCopyFileName ? SourceIni.GetFileName() : "", sIniString)

		return this
	}

	Merge(vOtherIni, bRemoveNonMatching = false, bOverwriteMatching = false, vExceptionsIni = "") {
		for sec, aKeysToVals in vOtherIni {
			if (!this.HasKey(sec))
				if (bRemoveNonMatching)
					this.DeleteSection(sec)
				 else this.AddSection(sec)

			for key, val in aKeysToVals {
				bMakeException := vExceptionsIni[sec].HasKey(key)

				if (this[sec].HasKey(key)) {
					if (bOverwriteMatching && !bMakeException)
						this[sec, key] := val
				} else {
					if (bRemoveNonMatching && !bMakeException)
						this.DeleteKey(sec, key)
					else if (!bRemoveNonMatching)
						this.AddKey(sec, key, val)
				}
			}
		}
		return
	}

	GetFileName() {
		return this.EasyIni_ReservedFor_m_sFile
	}

	GetOnlyIniFileName() {
		return SubStr(this.EasyIni_ReservedFor_m_sFile, InStr(this.EasyIni_ReservedFor_m_sFile,"\", false, -1)+1)
	}

	IsEmpty() {
		return (this.GetSections() == A_Blank
			&& !this.EasyIni_ReservedFor_TopComments.HasKey(1))
	}

	Reload() {
		if (FileExist(this.GetFileName()))
			this := class_EasyIni(this.GetFileName())
		return this
	}

	Save(sSaveAs="", bWarnIfExist=false) {
		if (sSaveAs == A_Blank)
			sFile := this.GetFileName()
		else {
			sFile := sSaveAs

			if (SubStr(sFile, StrLen(sFile)-3, 4) != ".ini")
				sFile .= ".ini"

			if (bWarnIfExist && FileExist(sFile)) {
				MsgBox, 4,, The file "%sFile%" already exists.`n`nAre you sure that you want to overwrite it?
				IfMsgBox, No
					return false
			}
		}

		bIsFirstLine := true,TTempString:=""
		for k, v in this.EasyIni_ReservedFor_TopComments
			sLastAddedLine := (A_Index == 1 ? "" : "`n") (v == Chr(14) ? "" : v)
			, TTempString.=sLastAddedLine
			, bIsFirstLine := false

		for section, aKeysToVals in this {
			sLastAddedLine := (bIsFirstLine ? "[" : "`n[") section "]"
			, TTempString.=sLastAddedLine
			, bIsFirstLine := false
			, sComments := this[section].EasyIni_ReservedFor_Comments["SectionComment"]
			Loop, Parse, sComments, `n
			{
				sLastAddedLine := "`n" (A_LoopField == Chr(14) ? "" : A_LoopField)
				if (Not TTempString~=sLastAddedLine . "$"&&sLastAddedLine<>"`n")
					TTempString.=sLastAddedLine
			}

			bEmptySection := true
			for key, val in aKeysToVals {
				bEmptySection := false
				, sLastAddedLine := "`n" key "=" val
				, TTempString.=sLastAddedLine

				, sComments := this[section].EasyIni_ReservedFor_Comments[key]
				Loop, Parse, sComments, `n
				{
					sLastAddedLine := "`n" (A_LoopField == Chr(14) ? "" : A_LoopField)
					if (Not TTempString~=sLastAddedLine . "$"&&sLastAddedLine<>"`n")
						TTempString.=sLastAddedLine
				}
			}
			if (bEmptySection) {
				sComments := this[section].EasyIni_ReservedFor_Comments["SectionComment"]
				Loop, Parse, sComments, `n
				{
					sLastAddedLine := "`n" (A_LoopField == Chr(14) ? "" : A_LoopField)
					if (Not TTempString~=sLastAddedLine . "$"&&sLastAddedLine<>"`n")
						TTempString.=sLastAddedLine
				}
			}
			TTempString.= "`n"
		}

		if (!IsStringEmpty(TTempString:=Trim(TTempString,"`n"))) {
			FileDelete, %sFile%
			FileAppend, % RegExReplace(TTempString,"[`r`n]{2,}","`n`n") "`n", %sFile%
		}
		return true
	}

	ToVar() {
		sTmpFile := "$$$EasyIni_Temp.ini"
		, this.Save(sTmpFile, !A_IsCompiled)
		FileRead, sIniAsVar, %sTmpFile%
		FileDelete, %sTmpFile%
		return sIniAsVar
	}
}

EasyIni_CreateBaseObj(parms*) {
	static base := {__Set: "EasyIni_Set", _NewEnum: "EasyIni_NewEnum", Delete: "Delete", Remove: "EasyIni_Remove", Insert: "EasyIni_Insert", InsertBefore: "EasyIni_InsertBefore"}
	return Object("_keys", Object(), "base", base, parms*)
}

EasyIni_Set(obj, parms*) {
	if parms.maxindex() > 2
		ObjInsert(obj, parms[1], EasyIni_CreateBaseObj())

	if (SubStr(parms[1], 1, 20) <> "EasyIni_ReservedFor_")
		ObjInsert(obj._keys, parms[1])
}

EasyIni_NewEnum(obj) {
	static base := Object("Next", "EasyIni_EnumNext")
	return Object("obj", obj, "enum", obj._keys._NewEnum(), "base", base)
}

EasyIni_EnumNext(e, ByRef k, ByRef v="") {
	if r := e.enum.Next(i,k)
		v := e.obj[k]
	return r
}

EasyIni_Remove(obj, parms*) {
	r := ObjRemove(obj, parms*)
	, Removed := []
	for k, v in obj._keys
		if not ObjHasKey(obj, v)
			Removed.Insert(k)
	for k, v in Removed
		ObjRemove(obj._keys, v, "")
	return r
}

EasyIni_Insert(obj, parms*) {
	r := ObjInsert(obj, parms*)
	, enum := ObjNewEnum(obj) 
	while enum[k] {
		for i, kv in obj._keys
			if (k = "_keys" || k = kv || SubStr(k, 1, 20) = "EasyIni_ReservedFor_" || SubStr(kv, 1, 20) = "EasyIni_ReservedFor_")
				continue 2
		ObjInsert(obj._keys, k)
	}
	return r
}

EasyIni_InsertBefore(obj, key, parms*) {
	OldKeys := obj._keys
	, obj._keys := []
	for idx, k in OldKeys { 
		if (k = key)
			break
		obj._keys.Insert(k)
	}

	r := ObjInsert(obj, parms*)
	, enum := ObjNewEnum(obj)
	while enum[k] {
		for i, kv in OldKeys
			if (k = "_keys" || k = kv) 
				continue 2
		ObjInsert(obj._keys, k)
	}

	for i, k in OldKeys {
		if (i < idx)
			continue
		obj._keys.Insert(k)
	}
	return r
}

IsStringEmpty(string) {
	if (string == Chr(14) or string == "`n" or string == "`r" or string == "`r`n" or string == "`n`r" or string == "")
		return true
	return false
}

CalcStringMD5(string, case=true) {
	static MD5_DIGEST_LENGTH := 16
	hModule := DllCall("LoadLibrary", "Str", "advapi32.dll", "Ptr")
	, VarSetCapacity(MD5_CTX, 104, 0)
	, DllCall("advapi32\MD5Init", "Ptr", &MD5_CTX)
	, DllCall("advapi32\MD5Update", "Ptr", &MD5_CTX, "AStr", string, "UInt", StrLen(string))
	, DllCall("advapi32\MD5Final", "Ptr", &MD5_CTX)
	Loop %MD5_DIGEST_LENGTH%
		outStr .= Format("{:02" (case ? "X" : "x") "}", NumGet(MD5_CTX, 87 + A_Index, "UChar"))
	return outStr, DllCall("FreeLibrary", "Ptr", hModule)
}

GetValue(sec, key, default) {
	IniVal:=this[sec][ key]

	if !IniVal
		this[sec][ key]:=default, IniVal := default

	return IniVal
}
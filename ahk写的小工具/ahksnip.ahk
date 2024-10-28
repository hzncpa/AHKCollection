;hzn 修改自scite的代码管理,暂时给vim用
Label_PreSetting:    ;{ 预设置
  #NoEnv
  #NoTrayIcon
  #SingleInstance force
  #Requires AutoHotkey v1.1.33+
  FileEncoding, UTF-8
;}

Label_DefVar:        ;{ 定义变量
  ver := 1,0
  progName := "vim代码管理"
	envget,vim,vim
	EnvGet,SoftDir,SoftDir
	global vim
	global SoftDir
  sdir = D:\OneDrive\SoftDir\SciTE\user\Scriptlets\
  scite = %SoftDir%\SciTE\

  if (!InStr(FileExist(sdir), "D"))
    FileCreateDir, %sdir%
;}

Label_DrawGUI:       ;{ 绘制窗体
  Gui, +Owner%scitehwnd% -MinimizeBox +HwndhGUI
  Gui, Margin, 10, 10
  Gui, Font, S9, %textFont%
  
  Gui, Add, Button, Section x10 w80 h30 gAddBtn, 新建
  Gui, Add, Button, ys w80 h30 gRenBtn, 重命名
  Gui, Add, Button, ys w80 h30 gSubBtn, 删除
  
  Gui, Add, Text, xs w40 h25 +0x200, 搜索：
  Gui, Add, Edit, x+10 yp w210 h25 vSearchStr gSearchChange
  Gui, Add, ListBox, xs w260 h480 vMainListbox gSelectLB HwndhListbox HScroll 0x100 Hidden
  Gui, Add, TreeView, xs yp w260 h480 vMainTreeView gSelectTR HScroll
  
  Gui, Add, Button, ys Section w115 h30 gToolbarBtn, 重启工具
  Gui, Add, Button, ys w115 h30 gInsertBtn, 插入到vim
  Gui, Add, Button, ys w115 h30 gOpenInSciTE, vim编辑
  Gui, Add, Button, ys w80 h30 gSaveBtn, 保存
  
  Gui, Add, Edit, xs w455 h515 vScriptPane WantTab HScroll
  
  Gui, Font, cNavy
  Gui, Add, Text, xs-270 vTipsPane, 使用技巧： 搜索内容后按 Ctrl+I 或 Alt+Enter 直接插入到vim 中。
  
  Gui, Show, , %progName% v%ver%
  GuiControl, Focus, SearchStr
  
  OnMessage(0x200, "tipsHandler")  ; WM_MouseMove
  
  gosub TreeViewUpdate
return
;}

GuiEscape:
GuiClose:            ;{ 关闭窗体
  ExitApp
return
;}

#If WinActive("ahk_id " hGUI)
^n::
AddBtn:              ;{ 新建
  Gui +OwnDialogs
  
  InputBox, fname2create, 新建代码片段, 输入要创建的代码片段名称`n`n格式1： 名称`n格式2： 分类_名称,,,,,,,, % getCategoryName()
  if ErrorLevel
    return
  if !fname2create
    return
  
  fname2create := validateFilename(fname2create)
  if (FileExist(sdir "\" fname2create ".ahk"))
  {
    MsgBox, 48, %progName% - 新建, 创建失败！`n`n 【%fname2create%】 已存在，请输入其他名称。
    return
  }
  
  FileAppend, % defaultahk, %sdir%\%fname2create%.ahk
  gosub CompleteUpdate
  _RC = 1
Return
;}

^r::
RenBtn:              ;{ 重命名
  Gui +OwnDialogs
  
  if (selected := getSelItemName())
  {
    InputBox, fname2create, 重命名代码片段, 输入代码片段的新名称`n`n格式1： 名称`n格式2： 分类_名称,,,,,,,, %selected%
    if ErrorLevel
      return
    if !fname2create
      return
    if (fname2create = selected)
      return
    
    fname2create := validateFilename(fname2create)
    if (FileExist(sdir "\" fname2create ".ahk"))
    {
      MsgBox, 48, %progName% - 重命名, 重命名失败！`n`n 【%fname2create%】 已存在，请输入其他名称。
      return
    }
    
    FileMove, %sdir%\%selected%.ahk, %sdir%\%fname2create%.ahk
    gosub CompleteUpdate
  }
  else
    showTip("没有选中项目！")
return
;}

^d::
SubBtn:              ;{ 删除
  Gui +OwnDialogs
  
  if (selected := getSelItemName())
  {
    MsgBox, 52, %progName% - 删除, 确认删除 【%selected%】 ？
    IfMsgBox, No
      return
    
    FileDelete, %sdir%\%selected%.ahk
    gosub CompleteUpdate
  }
  else
    showTip("没有选中项目！")
return
;}

^t::
ToolbarBtn:          ;{ 重启工具
Reload
return
;}

^i::
!enter::
InsertBtn:           ;{ 插入到vim
  GuiControlGet, text2insert,, ScriptPane
InsertDirect:
  text2insert := removeDescription(text2insert)
  if text2insert =
  {
    showTip("没有选中项目！")
    return
  }
  Clipboard:=text2insert
	WinActivate ahk_exe gvim.exe
	send,p
  ExitApp
return
;}


^o::
OpenInSciTE:         ;{ vim编辑
  path := getSelItemPath()
  if (FileExist(path))
  {
    vim(path)
    ExitApp
  }
  else
    showTip("没有选中项目！")
return
;}

^s::
SaveBtn:             ;{ 保存
  if (path := getSelItemPath())
  {
    GuiControlGet, text2save,, ScriptPane
    FileDelete, %path%
    FileAppend, % text2save, %path%
    showTip(ErrorLevel ? "保存失败" : "保存成功")
  }
  else
    showTip("没有选中项目！")
return
;}

F3::                 ;{ 搜索
  GuiControl,, SearchStr
  GuiControl, Focus, SearchStr
return
;}

#If WinActive("ahk_id " hGUI) and (showBlankListboxFirst = false) and isFocusOnSearchBar()
Up::                 ;{ 搜索框内按方向键可选择 ListBox 中的项目
Down::
  ControlSend,, {%A_ThisHotkey%}, ahk_id %hListbox%
return
;}

CompleteUpdate:      ;{ 更新全部
  gosub TreeViewUpdate
  gosub SearchChange
return
;}

TreeViewUpdate:      ;{ 更新 TreeView
  TV_Delete()
  
  ParentItemID := {}
  sn_with_type := []
  sn_cache := []
  
  Loop, %sdir%\*.ahk
  {
    SplitPath, A_LoopFileName,,,, sn
    
    ; 缓存全部项目给 SearchChange 搜索用
    sn_cache.Push(sn)
    
    ; 缓存带分类的项目
    if (InStr(sn, "_"))
    {
      sn_with_type.Push(sn)
      continue
    }
    
    ; 优先创建无分类的项目
		TV_Add(sn,, (fname2create = sn ? "Select" : ""))
  }
  
  ; 接着创建带分类的项目
  for k, sn in sn_with_type
  {
    t := StrSplit(sn, "_", "", 2)
    sType := t[1], sName := t[2]
    
    ; 创建分类
    if (!ParentItemID[sType])
      ParentItemID[sType] := TV_Add(sType)
    
    ; 分类中创建项目
		TV_Add(sName, ParentItemID[sType], (RegExReplace(fname2create, "^[^_]+_") = sName ? "Select" : ""))
  }
 if fname2create
    GuiControl, Focus, MainTreeView
return
;}

SearchChange:        ;{ 搜索框变动
  GuiControlGet, SearchStr,, SearchStr
  
  if (SearchStr="")
  {
    showBlankListboxFirst := true
    Guicontrol, Show, MainTreeView
    Guicontrol,, ScriptPane
    Guicontrol, Hide, MainListbox
    return
  }
  else if (showBlankListboxFirst != false)
  {
    showBlankListboxFirst := false
    GuiControl,, MainListbox, |
    Guicontrol, Show, MainListbox
    Guicontrol, Hide, MainTreeView
  }
  
  list := ""
  for k, itemName in sn_cache
  {
    ; 支持 “a b” 匹配 “acdbef”
    for k, v in StrSplit(SearchStr, " ")
			if (!tcmatch(itemName, v))
				continue, 2
    
    list .= "|" itemName
  }
  
  GuiControl,, MainListbox, % list ? list : "|"
  GuiControl, Choose, MainListbox, 1
  gosub, SelectLB
return
;}

SelectTR:            ;{ TreeView 选中
  if (A_GuiEvent != "S")  ; 只处理选中操作
    return
SelectLB:            ;{ Listbox 选中
  FileRead, ahkText, % getSelItemPath()
  GuiControl,, ScriptPane, % ahkText
return
;};}

tipsHandler()
{
  global TipsPane
  static pre_GuiControl:=""
  
  if (A_GuiControl!=pre_GuiControl)
  {
    pre_GuiControl := A_GuiControl
    switch, A_GuiControl
    {
      case "新建":          GuiControl, , TipsPane, 新建： Ctrl+N
      case "重命名":        GuiControl, , TipsPane, 重命名： Ctrl+R
      case "删除":          GuiControl, , TipsPane, 删除： Ctrl+D
      case "保存":          GuiControl, , TipsPane, 保存： Ctrl+S
      case "重启工具":  GuiControl, , TipsPane, 重启工具： Ctrl+T
      case "插入到vim":  GuiControl, , TipsPane, 插入到vim： Ctrl+I 或 Alt+Enter
      case "vim编辑": GuiControl, , TipsPane, vim编辑： Ctrl+O
      case "SearchStr":     GuiControl, , TipsPane, 搜索： F3`t搜索语法： “() pp” 可匹配 apple()
      Default:              GuiControl, , TipsPane, 使用技巧： 搜索内容后按 Ctrl+I 或 Alt+Enter 直接插入到vim 中。
    }
  }
}

showTip(text)
{
  ToolTip, %text%
  SetTimer, CloseToolTip, -2000
  return
  
  CloseToolTip:
    ToolTip
  return
}

getSelItemPath()
{
  global sdir
  
  selItemName := getSelItemName()
  if (selItemName)
    return, sdir "\" selItemName ".ahk"
}

getSelItemName()
{
  global SearchStr, MainListbox
  
  GuiControlGet, SearchStr,, SearchStr
  if (SearchStr != "")
    GuiControlGet, out,, MainListbox
  else
  {
    id := TV_GetSelection()
    
    if (TV_GetChild(id))
      return
    
    TV_GetText(out1, TV_GetParent(id))
    TV_GetText(out2, id)
    out := out1 ? out1 "_" out2 : out2
  }
  
  return, out
}

getCategoryName()
{
  id := TV_GetSelection()
  
  if (id)
  {
    if (TV_GetChild(id))
      TV_GetText(out, id)
    else if (TV_GetParent(id))
      TV_GetText(out, TV_GetParent(id))
  }
  
  return out="" ? "" : out "_"
}

validateFilename(str)
{
  str := StrReplace(str, "`\")
  str := StrReplace(str, "`/")
  str := StrReplace(str, "`:")
  str := StrReplace(str, "`*")
  str := StrReplace(str, "`?")
  str := StrReplace(str, """")
  str := StrReplace(str, "`<")
  str := StrReplace(str, "`>")
  str := StrReplace(str, "`|")
  str := StrReplace(str, "`r")
  str := StrReplace(str, "`n")
  
  ; 创建的是文件夹的时候，最后一个字符不能是 “.” ，否则会失败。
  ; 创建的是文件时，则会自动删掉最后的 “.” 。
  ; 所以无论何种情况，最后一个字符是 “.” 时，都要被干掉。
  return, RTrim(str, ".")
}

isFocusOnSearchBar()
{
  GuiControlGet, out, FocusV
  return, out="SearchStr" ? true : false
}

removeDescription(text)
{
  ; 正则严格匹配第一个以 /** 开头
  ;                   以 */ 结束的多行注释
  ; 这种注释被设计为即兼容 ahk 原版语法，同时又可以被单独识别而另做它用，并且其长度还很方便代码对齐。
  ; 目前的作用是可在管理器中描述代码片段作者、用法等信息，同时在插入 scite 时被自动剔除以维持简洁。
  ; 未来还可能被用来存储一些命令，例如识别里面的 pos 值，从而在插入代码后再将光标移动到指定位置。
  return RegExReplace(text
                    , "m)(*ANYCRLF)"
                    . "(^\Q/**\E)"
                    . "(.*[\r\n]+)"
                    . "(?s)(.*?)"
                    . "\Q*/\E[\r\n]+"
                    , "", "", 1)
}
vim(path){
run %vim%\gvim.exe  -p --remote-tab-silent %path%
}



TCMatchOn(dllPath = "") {
    if(g_TCMatchModule)
        return g_TCMatchModule
	g_TCMatchModule := DllCall("LoadLibrary", "Str", dllPath, "Ptr")
    return g_TCMatchModule
}

TCMatchOff() {
    DllCall("FreeLibrary", "Ptr", g_TCMatchModule)
    g_TCMatchModule := ""
}

TCMatch(aHaystack, aNeedle) {
	global
	static  g_TCMatchModule
	 ;64 or 32
	 ;MatchFileW := (A_PtrSize == 8 ) ? "TCMatch64\MatchFileW" : "TCMatch\MatchFileW"
	 ;dllPath := A_ScriptDir "\Lib\tcmatch\" ((A_PtrSize == 8 ) ? "TCMatch64" : "TCMatch") ".dll"
	 ;32
	 envget,softdir,softdir
	 envget,commander_path,commander_path
	 matchfilew:=(softdir!="")?Softdir "\tc\TCMatch\MatchFileW":commander_path "\TCMatch\MatchFileW"
	 dllPath:=(Softdir!="")?Softdir "\tc\tcmatch.dll":Commander_path "\tcmatch.dll"
	g_TCMatchModule := TCMatchOn(dllPath)
    Return DllCall(MatchFileW, "WStr", aNeedle, "WStr", aHaystack)
}



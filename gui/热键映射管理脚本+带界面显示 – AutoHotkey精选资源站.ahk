; 一套适合大众的带界面按键修改脚本示例
#NoEnv
#SingleInstance Force
SetBatchLines -1
SetWorkingDir %A_ScriptDir%

Menu Tray, Icon, shell32.dll, 174
Menu Tray, NoStandard
Menu Tray, Add, 设置热键(&E), 托盘编辑标签
Menu Tray, Icon, 设置热键(&E), shell32.dll, 174, 16
Menu Tray, Add
Menu Tray, Add, 重启脚本(&R), 重启脚本
Menu Tray, Icon, 重启脚本(&R), shell32.dll, 239, 16
Menu Tray, Add
Menu Tray, Add, 关闭脚本(&X), 关闭脚本
Menu Tray, Icon, 关闭脚本(&X), shell32.dll, 132, 16
Menu Tray, Color, ffffff
Menu Tray, Default, 设置热键(&E)
热键开关 := 1

设置热键:
需配置的变量名:=[ ], 需启动的变量名:=[ ]
Gui Destroy
Gui +HwndGuiID -MaximizeBox -MinimizeBox
Gui, Font, s9, Microsoft YaHei
Gui, Color, 87CEEB
Gui, Add, StatusBar,,自定义热键管理
Gui, Add, Text, x60 y+15,新热键                     原热键
Gui, Add, Text, x20 y40 , (1)
Gui, Add, Text, x20 y+7, (2)
Gui, Add, Text, x20 y+7, (3)
Gui, Add, Text, x20 y+7, (4)
Gui, Add, Text, x20 y+7, (5)
Gui, Add, Text, x20 y+7, (6)
Gui, Add, Text, x20 y+7, (7)
Gui, Add, Text, x20 y+7, (8)
Gui, Add, Text, x20 y+7, (9)
Gui, Add, Text, x20 y+7, (10)
Gui, Add, Text, x20 y+7, (11)
Gui, Add, Text, x20 y+7, (12)
Gui, Add, Text, x135 y40 , →
Gui, Add, Text, y+7, →
Gui, Add, Text, y+7, →
Gui, Add, Text, y+7, →
Gui, Add, Text, y+7, →
Gui, Add, Text, y+7, →
Gui, Add, Text, y+7, →
Gui, Add, Text, y+7, →
Gui, Add, Text, y+7, →
Gui, Add, Text, y+7, →
Gui, Add, Text, y+7, →
Gui, Add, Text, y+7, →
Gui, Add, Hotkey, x45 y40 w85 h20 v变量_触发1
Gui, Add, Hotkey, y+4 w85 h20 v变量_触发2
Gui, Add, Hotkey, y+4 w85 h20 v变量_触发3
Gui, Add, Hotkey, y+4 w85 h20 v变量_触发4
Gui, Add, Hotkey, y+4 w85 h20 v变量_触发5
Gui, Add, Hotkey, y+4 w85 h20 v变量_触发6
Gui, Add, Hotkey, y+4 w85 h20 v变量_触发7
Gui, Add, Hotkey, y+4 w85 h20 v变量_触发8
Gui, Add, Hotkey, y+4 w85 h20 v变量_触发9
Gui, Add, Hotkey, y+4 w85 h20 v变量_触发10
Gui, Add, Hotkey, y+4 w85 h20 v变量_触发11
Gui, Add, Hotkey, y+4 w85 h20 v变量_触发12
Gui, Add, Hotkey, x155 y40 w85 h20 v变量_技能1
Gui, Add, Hotkey, y+4 w85 h20 v变量_技能2
Gui, Add, Hotkey, y+4 w85 h20 v变量_技能3
Gui, Add, Hotkey, y+4 w85 h20 v变量_技能4
Gui, Add, Hotkey, y+4 w85 h20 v变量_技能5
Gui, Add, Hotkey, y+4 w85 h20 v变量_技能6
Gui, Add, Hotkey, y+4 w85 h20 v变量_技能7
Gui, Add, Hotkey, y+4 w85 h20 v变量_技能8
Gui, Add, Hotkey, y+4 w85 h20 v变量_技能9
Gui, Add, Hotkey, y+4 w85 h20 v变量_技能10
Gui, Add, Hotkey, y+4 w85 h20 v变量_技能11
Gui, Add, Hotkey, y+4 w85 h20 v变量_技能12
Gui, Add, Button, x45 y330 w85 g标签_启动, 启用热键
Gui, Add, Button, x155 y330 w85 g标签_暂停, 暂停热键
需配置的变量名.Push("变量_触发1","变量_技能1")
需启动的变量名.Push("变量_触发1","变量_技能1")
需配置的变量名.Push("变量_触发2","变量_技能2")
需启动的变量名.Push("变量_触发2","变量_技能2")
需配置的变量名.Push("变量_触发3","变量_技能3")
需启动的变量名.Push("变量_触发3","变量_技能3")
需配置的变量名.Push("变量_触发4","变量_技能4")
需启动的变量名.Push("变量_触发4","变量_技能4")
需配置的变量名.Push("变量_触发5","变量_技能5")
需启动的变量名.Push("变量_触发5","变量_技能5")
需配置的变量名.Push("变量_触发6","变量_技能6")
需启动的变量名.Push("变量_触发6","变量_技能6")
需配置的变量名.Push("变量_触发7","变量_技能7")
需启动的变量名.Push("变量_触发7","变量_技能7")
需配置的变量名.Push("变量_触发8","变量_技能8")
需启动的变量名.Push("变量_触发8","变量_技能8")
需配置的变量名.Push("变量_触发9","变量_技能9")
需启动的变量名.Push("变量_触发9","变量_技能9")
需配置的变量名.Push("变量_触发10","变量_技能10")
需启动的变量名.Push("变量_触发10","变量_技能10")
需配置的变量名.Push("变量_触发11","变量_技能11")
需启动的变量名.Push("变量_触发11","变量_技能11")
需配置的变量名.Push("变量_触发12","变量_技能12")
需启动的变量名.Push("变量_触发12","变量_技能12")
Gosub, 标签_读配置
OnExit, 标签_退出脚本时写配置
; 判断配置文件，让第一次运行时，自动弹出设置界面。之后运行将默认托盘最小化并开启热键映射
if (!FileExist(A_ScriptDir . "\" A_ScriptName ".ini") or 通过托盘显示=1)
  Gui, Show, w280 h390, AHK热键映射管理
 else
  Gosub 标签_启动
return

托盘编辑标签:
通过托盘显示:=1
Gosub 设置热键
Return

重启脚本:
Reload
关闭脚本:
ExitApp
Return

标签_退出脚本时写配置:
Gosub, 标签_写配置
Gosub, 关闭脚本
Return

标签_读配置:
  For i,k in 需配置的变量名
    v:=读配置(k), 写控件(k, v)
return

标签_写配置:
  For i,k in 需配置的变量名
    v:=读控件(k), 写配置(k, v)
return

标签_启动:
  For i,k in 映射表
    Hotkey, % 解码(k), 标签_发送, Off UseErrorLevel
  映射表:=[]
  loop, % 需启动的变量名.MaxIndex()//2
  {
    k:=读控件(需启动的变量名[2*A_Index-1])
    v:=读控件(需启动的变量名[2*A_Index])
    if (k!="" and v!="")
    {
      映射表[编码(k)]:=v
      Hotkey, %k%, 标签_发送, On UseErrorLevel
    }
  }
  if WinExist("ahk_id " GuiID) {
    MsgBox, 4096,, 设置并成功 启用热键 修改！, 1
    Gosub, 标签_写配置
  }
return

标签_发送:
  Send % 映射表[编码(A_ThisHotkey)]
return

标签_暂停:
  if (热键开关 := !热键开关)
    GuiControl,, 热键已暂停, 暂停热键
   else
    GuiControl,, 暂停热键, 热键已暂停
  Suspend
return

读控件(k) {
  GuiControlGet, v,, %k%
  return v
}

写控件(k, v) {
  GuiControl,, %k%, %v%
}

读配置(k) {
  配置文件:=A_ScriptDir . "\" A_ScriptName ".ini"
  IniRead, v, %配置文件%, Setting, %k%, %A_Space%
  return v
}

写配置(k, v) {
  配置文件:=A_ScriptDir . "\" A_ScriptName ".ini"
  IniWrite, %v%, %配置文件%, Setting, %k%
}

编码(s) {
  loop, Parse, s
    ss.="u" . Ord(A_LoopField)
  return ss
}

解码(s) {
  loop, Parse, s, u
    ss.=Chr(A_LoopField)
  return ss
}
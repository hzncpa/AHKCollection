; һ���ʺϴ��ڵĴ����水���޸Ľű�ʾ��
#NoEnv
#SingleInstance Force
SetBatchLines -1
SetWorkingDir %A_ScriptDir%

Menu Tray, Icon, shell32.dll, 174
Menu Tray, NoStandard
Menu Tray, Add, �����ȼ�(&E), ���̱༭��ǩ
Menu Tray, Icon, �����ȼ�(&E), shell32.dll, 174, 16
Menu Tray, Add
Menu Tray, Add, �����ű�(&R), �����ű�
Menu Tray, Icon, �����ű�(&R), shell32.dll, 239, 16
Menu Tray, Add
Menu Tray, Add, �رսű�(&X), �رսű�
Menu Tray, Icon, �رսű�(&X), shell32.dll, 132, 16
Menu Tray, Color, ffffff
Menu Tray, Default, �����ȼ�(&E)
�ȼ����� := 1

�����ȼ�:
�����õı�����:=[ ], �������ı�����:=[ ]
Gui Destroy
Gui +HwndGuiID -MaximizeBox -MinimizeBox
Gui, Font, s9, Microsoft YaHei
Gui, Color, 87CEEB
Gui, Add, StatusBar,,�Զ����ȼ�����
Gui, Add, Text, x60 y+15,���ȼ�                     ԭ�ȼ�
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
Gui, Add, Text, x135 y40 , ��
Gui, Add, Text, y+7, ��
Gui, Add, Text, y+7, ��
Gui, Add, Text, y+7, ��
Gui, Add, Text, y+7, ��
Gui, Add, Text, y+7, ��
Gui, Add, Text, y+7, ��
Gui, Add, Text, y+7, ��
Gui, Add, Text, y+7, ��
Gui, Add, Text, y+7, ��
Gui, Add, Text, y+7, ��
Gui, Add, Text, y+7, ��
Gui, Add, Hotkey, x45 y40 w85 h20 v����_����1
Gui, Add, Hotkey, y+4 w85 h20 v����_����2
Gui, Add, Hotkey, y+4 w85 h20 v����_����3
Gui, Add, Hotkey, y+4 w85 h20 v����_����4
Gui, Add, Hotkey, y+4 w85 h20 v����_����5
Gui, Add, Hotkey, y+4 w85 h20 v����_����6
Gui, Add, Hotkey, y+4 w85 h20 v����_����7
Gui, Add, Hotkey, y+4 w85 h20 v����_����8
Gui, Add, Hotkey, y+4 w85 h20 v����_����9
Gui, Add, Hotkey, y+4 w85 h20 v����_����10
Gui, Add, Hotkey, y+4 w85 h20 v����_����11
Gui, Add, Hotkey, y+4 w85 h20 v����_����12
Gui, Add, Hotkey, x155 y40 w85 h20 v����_����1
Gui, Add, Hotkey, y+4 w85 h20 v����_����2
Gui, Add, Hotkey, y+4 w85 h20 v����_����3
Gui, Add, Hotkey, y+4 w85 h20 v����_����4
Gui, Add, Hotkey, y+4 w85 h20 v����_����5
Gui, Add, Hotkey, y+4 w85 h20 v����_����6
Gui, Add, Hotkey, y+4 w85 h20 v����_����7
Gui, Add, Hotkey, y+4 w85 h20 v����_����8
Gui, Add, Hotkey, y+4 w85 h20 v����_����9
Gui, Add, Hotkey, y+4 w85 h20 v����_����10
Gui, Add, Hotkey, y+4 w85 h20 v����_����11
Gui, Add, Hotkey, y+4 w85 h20 v����_����12
Gui, Add, Button, x45 y330 w85 g��ǩ_����, �����ȼ�
Gui, Add, Button, x155 y330 w85 g��ǩ_��ͣ, ��ͣ�ȼ�
�����õı�����.Push("����_����1","����_����1")
�������ı�����.Push("����_����1","����_����1")
�����õı�����.Push("����_����2","����_����2")
�������ı�����.Push("����_����2","����_����2")
�����õı�����.Push("����_����3","����_����3")
�������ı�����.Push("����_����3","����_����3")
�����õı�����.Push("����_����4","����_����4")
�������ı�����.Push("����_����4","����_����4")
�����õı�����.Push("����_����5","����_����5")
�������ı�����.Push("����_����5","����_����5")
�����õı�����.Push("����_����6","����_����6")
�������ı�����.Push("����_����6","����_����6")
�����õı�����.Push("����_����7","����_����7")
�������ı�����.Push("����_����7","����_����7")
�����õı�����.Push("����_����8","����_����8")
�������ı�����.Push("����_����8","����_����8")
�����õı�����.Push("����_����9","����_����9")
�������ı�����.Push("����_����9","����_����9")
�����õı�����.Push("����_����10","����_����10")
�������ı�����.Push("����_����10","����_����10")
�����õı�����.Push("����_����11","����_����11")
�������ı�����.Push("����_����11","����_����11")
�����õı�����.Push("����_����12","����_����12")
�������ı�����.Push("����_����12","����_����12")
Gosub, ��ǩ_������
OnExit, ��ǩ_�˳��ű�ʱд����
; �ж������ļ����õ�һ������ʱ���Զ��������ý��档֮�����н�Ĭ��������С���������ȼ�ӳ��
if (!FileExist(A_ScriptDir . "\" A_ScriptName ".ini") or ͨ��������ʾ=1)
  Gui, Show, w280 h390, AHK�ȼ�ӳ�����
 else
  Gosub ��ǩ_����
return

���̱༭��ǩ:
ͨ��������ʾ:=1
Gosub �����ȼ�
Return

�����ű�:
Reload
�رսű�:
ExitApp
Return

��ǩ_�˳��ű�ʱд����:
Gosub, ��ǩ_д����
Gosub, �رսű�
Return

��ǩ_������:
  For i,k in �����õı�����
    v:=������(k), д�ؼ�(k, v)
return

��ǩ_д����:
  For i,k in �����õı�����
    v:=���ؼ�(k), д����(k, v)
return

��ǩ_����:
  For i,k in ӳ���
    Hotkey, % ����(k), ��ǩ_����, Off UseErrorLevel
  ӳ���:=[]
  loop, % �������ı�����.MaxIndex()//2
  {
    k:=���ؼ�(�������ı�����[2*A_Index-1])
    v:=���ؼ�(�������ı�����[2*A_Index])
    if (k!="" and v!="")
    {
      ӳ���[����(k)]:=v
      Hotkey, %k%, ��ǩ_����, On UseErrorLevel
    }
  }
  if WinExist("ahk_id " GuiID) {
    MsgBox, 4096,, ���ò��ɹ� �����ȼ� �޸ģ�, 1
    Gosub, ��ǩ_д����
  }
return

��ǩ_����:
  Send % ӳ���[����(A_ThisHotkey)]
return

��ǩ_��ͣ:
  if (�ȼ����� := !�ȼ�����)
    GuiControl,, �ȼ�����ͣ, ��ͣ�ȼ�
   else
    GuiControl,, ��ͣ�ȼ�, �ȼ�����ͣ
  Suspend
return

���ؼ�(k) {
  GuiControlGet, v,, %k%
  return v
}

д�ؼ�(k, v) {
  GuiControl,, %k%, %v%
}

������(k) {
  �����ļ�:=A_ScriptDir . "\" A_ScriptName ".ini"
  IniRead, v, %�����ļ�%, Setting, %k%, %A_Space%
  return v
}

д����(k, v) {
  �����ļ�:=A_ScriptDir . "\" A_ScriptName ".ini"
  IniWrite, %v%, %�����ļ�%, Setting, %k%
}

����(s) {
  loop, Parse, s
    ss.="u" . Ord(A_LoopField)
  return ss
}

����(s) {
  loop, Parse, s, u
    ss.=Chr(A_LoopField)
  return ss
}
#SingleInstance Force ;{{{

loop, %0%
{
	param := %A_Index% ; Fetch the contents of the variable whose name is contained in A_Index.
	params .= A_Space . param
}
ShellExecute := A_IsUnicode ? "shell32\ShellExecute":"shell32\ShellExecuteA"
if not A_IsAdmin
{
	if A_IsCompiled
		DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_ScriptFullPath, str, params , str, A_WorkingDir, int, 1)
	else
		DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_AhkPath, str, """" . A_ScriptFullPath . """" . A_Space . params, str, A_WorkingDir, int, 1)
	ExitApp
}
 ;}}}
按键 := ["/","*","-","+",7,8,9,"=",4,5,6,"←",1,2,3,"␣","00","0",".","↵","大写","osk","cal"]
行数 := 6
列数 := 4
按钮文本大小 := 14
键宽 := 50
键高 := 按钮文本大小 * 2.5
间距 := 5
Gui, Ai:+AlwaysOnTop +E0x08000000 +HwndAI_Hwnd +Owner +E0x02000000 +ToolWindow  
Gui, Ai:Font, s10, 微软雅黑
Gui, Ai:Margin, 10 , 10
Gui, Ai:Font, s%按钮文本大小%, 微软雅黑

换行计数 := 0
新行 := 1
按钮总数 := 行数 * 列数
Loop % 按钮总数
{
    换行计数 += 1
    _Lift := "x+" 间距
    _Top := ""
    If (A_Index = 1)
        _Lift := "x10", _Top := "y15"
    If (换行计数 = 列数 + 1){
        _Lift := "x10", _Top := "y" 15 + (键高+间距) * 新行 
        换行计数 := 1
        新行 += 1
    }
    Buttonid := "脚本" . A_Index
    Gui, Ai:Add, Button, %_Lift% %_Top% h%键高% w%键宽% v%Buttonid% gRunScript
}
For k,v in 按键 {
    GuiControl,Ai:Text , 脚本%k%, % v
}
MouseGetPos,x,y
Gui, Ai:Show,X%x% Y%y%,数字键盘plus
return
RunScript:
Switch A_GuiControl
{
case "脚本17":
	send,00
case "脚本19":
	send,{text}.
case "脚本12":
	send,{BackSpace}
case "脚本16":
	send,{Space}
case "脚本20":
	send,{enter}
case "脚本21":
	send,^c
	ClipWait,1,1
	Clipboard:=dmoney(Clipboard)
	send,^v
case "脚本22":
	run osk
case "脚本23":
	run calc
Default:
	Send % "{" 按键[RegExReplace(A_GuiControl,"脚本")] "}"
}
return
#IfWinActive ahk_exe osk.exe
MButton:: GoSub ai
RButton:: GoSub ai
#IfWinActive
#IfWinActive 计算器
MButton:: GoSub ai
RButton:: GoSub ai
#IfWinActive
ai:
WinMinimize,ahk_exe osk.exe
WinClose,计算器
MouseGetPos,x,y
Gui, Ai:Show,X%x% Y%y%,数字键盘plus
return

AiGuiescape:
Aiguiclose:
exitapp


;digit money; {{{
; 金额小写变大写函数
dmoney(SmallNum){
    ;从控件中取得数字值
    NumStr:=
	;删除回车
	StringReplace,NumStr,SmallNum ,`n`r,,all      ;换行回车
	StringReplace,NumStr,NumStr ,`n,,all      ;换行
	StringReplace,NumStr,NumStr ,`r,,all      ;回车
     ;删除空格
    StringReplace,NumStr,NumStr ,` ,,all      ;转义字符+半角空格
    StringReplace,NumStr,NumStr ,`　,,all         ;转义字符+全角空格
    ;删除千位符","
    StringReplace,NumStr,NumStr , `,,,all
    ;MsgBox %NumStr%
     
     ;数据是否为数字
     if (RegExMatch(numstr,"^(\-|\+)?\d+(\.\d+)?$")=0)
    {
        MsgBox, 48, 提示, 要转换的内容不是数值
        return
    }
    
    ;小写转大写的映射数组
    ;NumberArray := Object()
    NumberArray0 := "零"
    NumberArray1 := "壹"
    NumberArray2 := "贰"
    NumberArray3 := "叁"
    NumberArray4 := "肆"
    NumberArray5 := "伍"
    NumberArray6 := "陆"
    NumberArray7 := "柒"
    NumberArray8 := "捌"
    NumberArray9 := "玖"
    ;数位数组
    DigitPlace0 := "元"
    DigitPlace1 := "拾"
    DigitPlace2 := "佰"
    DigitPlace3 := "仟"
    DigitPlace4 := "万"
    DigitPlace5 := "拾"
    DigitPlace6 := "佰"
    DigitPlace7 := "仟"
    DigitPlace8 := "亿"
    DigitPlace9 := "拾"
    DigitPlace10 := "佰"
    DigitPlace12 := "仟"
    DigitPlace13 := "万"
    ;币值
    Valuta0 := "元"
    Valuta1 := "角"
    Valuta2 := "分"
    ;小数点前
    ;StrBeforeRadix :="人民币 "
    StrBeforeRadix :=
    ;小数点后
    StrAfterRadix :=
    ;整
    zheng :="整"
    ;需要用到的模式匹配
    StrPattern :=
    ;临时用变量
    TempStr1 :=
    TempStr2 :=
    i :=0
    ;结果字符串
    TransResult :=
    
    ;找到小数点位置
    RadixPointLocation:=0
    RadixPointLocation := instr(Numstr,".")
    ;开始转换
    ;先转换小数点后的小数
    If RadixPointLocation = 0
    {
        ;数为整数
        StrAfterRadix := Valuta0 . zheng
    } Else  {
        ;不是整数，先读取小数部分
        TempStr1 := substr(Numstr,RadixPointLocation+1)
        i = 1
        NCount :=strlen(TempStr1)
        loop %NCount%
        {
            NewID:=substr(TempStr1,i,1)
            StrAfterRadix := StrAfterRadix . NumberArray%NewID% . valuta%i%
            i := i + 1
        }
        ;处理小数的各种特殊情况
        stringreplace,StrAfterRadix,StrAfterRadix,零分, 整,All
        stringreplace,StrAfterRadix,StrAfterRadix,零角, 零,All
        stringreplace,StrAfterRadix,StrAfterRadix,零零, ,All
        stringreplace,StrAfterRadix,StrAfterRadix,零整, 整,All
        If strlen(StrAfterRadix) = 0 Or strlen(StrAfterRadix) = 2 Then
           StrAfterRadix := StrAfterRadix . "整"
    }
 
    if RadixPointLocation = 0
    {
        count1:=strlen(Numstr)
        TempStr1 := substr(Numstr,1, count1)
    }
    else
    {
        TempStr1 := substr(Numstr,1, RadixPointLocation-1)
    }
 
    ;If strlen(TempStr1) > 13   Return "数字太大，本程序无法转换" . numstr
    i := strlen(TempStr1) - 1
    j :=1
        MCount :=strlen(TempStr1)
        loop %MCount%
        {
            NewID:=substr(TempStr1,j,1)
            StrBeforeRadix := StrBeforeRadix . NumberArray%NewID% . Digitplace%i%
            i := i- 1
            j := j+1
        }
    stringreplace,StrBeforeRadix,StrBeforeRadix,零拾, 零,All
    stringreplace,StrBeforeRadix,StrBeforeRadix,零佰, 零,All
    stringreplace,StrBeforeRadix,StrBeforeRadix,零仟, 零,All
    transresult := StrBeforeRadix . StrAfterradix
    ;MsgBox %transresult%
    ;处理多个0的情况
    findzero := False
    mystr  := ""
    TempStr2 := ""
    i :=1
    NNCount :=strlen(transresult)
    loop %NNCount%
    {
        TempStr1:=substr(transresult,i,1)
        If (TempStr1 = "零")
            {
                findzero := True
                mystr := ""
            }  Else {
                If findzero
                {
                    mystr := "零" . TempStr1
                    findzero := False
                } Else {
                    mystr := TempStr1
                }
            }
        TempStr2 :=TempStr2 . mystr
        i+=1
    }
 
    StringReplace,TempStr2,TempStr2,零万, 万,All
    StringReplace,TempStr2,TempStr2,零亿, 亿,All
    StringReplace,TempStr2,TempStr2,零元, 元,All
	StringReplace,TempStr2,TempStr2,元元, 元,All
    transresult := TempStr2
    ;MsgBox %transresult%
    Return transresult
}
; }}}

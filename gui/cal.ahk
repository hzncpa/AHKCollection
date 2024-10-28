name := "MicroCalculator v1.4"
Gui, Add, Edit, x12 y9 w120 h70 vEdit hwndHandle gEdit,
Gui, Add, Button, x12 y79 w30 h20 g!, n!
Gui, Add, CheckBox, x42 y79 w30 h20 gAOT, #
Gui, Add, Button, x102 y79 w30 h20 gIsPrime, IsPr
Gui, Add, Button, x12 y99 w30 h20 g`%, `%
Gui, Add, Button, x42 y99 w30 h20 g^, x^y
Gui, Add, Button, x72 y99 w30 h20 g√, √
Gui, Add, Button, x102 y99 w30 h20 g/, /
Gui, Add, Button, x102 y119 w30 h20 g*, x
Gui, Add, Button, x102 y139 w30 h20 g-, -
Gui, Add, Button, x102 y159 w30 h20 g+, +
Gui, Add, Button, x102 y179 w30 h20 gEqual, =
Gui, Add, Button, x72 y179 w30 h20 g., .
Gui, Add, Button, x12 y179 w15 h20 gOrder, <
Gui, Add, Button, x27 y179 w15 h20 gOrderReverse, >
Gui, Add, Edit, x72 y79 w30 h20 vRound,
Gui, Add, UpDown, x82 y79 w20 h20 gEdit, 2
Gui, Add, Button, x42 y179 w30 h20 g0, 0
Gui, Add, Button, x12 y159 w30 h20 g1, 1
Gui, Add, Button, x42 y159 w30 h20 g2, 2
Gui, Add, Button, x72 y159 w30 h20 g3, 3
Gui, Add, Button, x12 y139 w30 h20 g4, 4
Gui, Add, Button, x42 y139 w30 h20 g5, 5
Gui, Add, Button, x72 y139 w30 h20 g6, 6
Gui, Add, Button, x12 y119 w30 h20 g7, 7
Gui, Add, Button, x42 y119 w30 h20 g8, 8
Gui, Add, Button, x72 y119 w30 h20 g9, 9
Gui, Add, StatusBar, gSB vSB, Welcome!
SB_SetParts(73)
Menu, Menu, Add, 清除
Menu, 历史, Add, 1, 历史
Menu, 历史, Add, 2, 历史
Menu, 历史, Add, 3, 历史
Menu, 历史, Add, 4, 历史
Menu, 历史, Add, 5, 历史
Menu, 历史, Add, 6, 历史
Menu, 历史, Add, 7, 历史
Menu, 历史, Add, 8, 历史
Menu, 历史, Add, 9, 历史
Menu, 历史, Add, 10, 历史
Menu, Menu, Add, 历史, :历史
Gui, Menu, Menu
Gui, Show, h222 w146, %name%
return

guiescape:
GuiClose:
		gui submit
		try
			clipboard:=dmoney(edit)
		sleep 300
		tooltip clipboard
		send ^v
		sleep 400
    ExitApp

FocusBack:
history++
Menu, 历史, Rename, %history%&, %Edit%=%numsym%
if (history = 10)
  history := 0
GuiControl, Text, Edit1, %numsym%
GuiControl, Focus, Edit1 
SendMessage, 0xB1, -2, -1,, ahk_id %Handle%
SendMessage, 0xB7,,,, ahk_id %Handle%
numsym := 0
return

Edit:
Gui, Submit, NoHide
if InStr(Edit, "!") > 0
  numsym := ZTrim(Fac(RTrim(Edit, "!")))
if InStr(Edit, "!") = 0
  numsym := Mather.Evaluate(Edit)
SB_SetText(numsym, 2)
return

SB:
Gui, Submit, NoHide
GuiControl, Text, Edit1, %SB%
SB_SetText(Edit)
Goto, Edit
return

历史:
GuiControl, Text, Edit1, % StrReplace(SubStr(A_ThisMenuItem, 1, InStr(A_ThisMenuItem, "=")), "=")
GuiControl, Focus, Edit1 
SendMessage, 0xB1, -2, -1,, ahk_id %Handle%
SendMessage, 0xB7,,,, ahk_id %Handle%
Goto, Edit
return

CType:
Gui, +OwnDialogs
MsgBox, 262192, Dev Note, This is still a WIP!!, 0
return

清除:
GuiControl, Text, Edit1
return

0:
1:
2:
3:
4:
5:
6:
7:
8:
9:
!:
^:
+:
-:
*:
/:
%:
.:
√:
Gui, Submit, NoHide
numsym := Edit A_ThisLabel
if (A_ThisLabel = "√")
  numsym := A_ThisLabel Edit
Goto, FocusBack
return

Order:
Gui, Submit, NoHide
Sort, Edit, N D,
numsym := Edit
Goto, FocusBack
return

OrderReverse:
Gui, Submit, NoHide
Sort, Edit, N R D,
numsym := Edit
Goto, FocusBack
return

AOT:
Winset, Alwaysontop, , A
return

IsPrime:
Gui, Submit, NoHide
GuiControl, Text, Button3, % IsPrime(Edit)
Sleep, 1000
GuiControl, Text, Button3, IsPr
return

Equal:
$Enter::
if WinActive(name)
{
  Gui, Submit, NoHide
  SB_SetText(Edit)
  if InStr(Edit, "!") > 0
    numsym := ZTrim(Fac(RTrim(Edit, "!")))
  if InStr(Edit, "!") = 0
    numsym := Mather.Evaluate(Edit)
  GoSub, FocusBack
  GuiControlGet, clipboard, , Edit1, 
}
if WinActive(name) = 0
  Send, {enter}
return

$^Backspace::
ifWinActive ahk_class AutoHotkeyGUI
  Send ^+{Left}{Backspace}
ifWinNotActive ahk_class AutoHotkeyGUI
  Send, ^{backspace}
return

ZTrim(x) {
  global Round
  x := Round(x, Round)
  IfInString, x, .00
  x := % Floor(x)
  return x
}
IsPrime(n,k=2) {
  d := k+(k<7 ? 1+(k>2) : SubStr("6-----4---2-4---2-4---6-----2",Mod(k,30),1)) 
  Return n < 3 ? n>1 : Mod(n,k) ? (d*d <= n ? IsPrime(n,d) : "Yes") : "No"
}
Fac(x) {
  var := 1
  Loop, %x%
    var *= A_Index
  return var
}
Per(x, y) {
  Per :=(x/100)*y
  return Per
}
class Mather {
  Tokenize(Source) {
    Tokens := []
    
    while (RegexMatch(Source, "Ox)(?<Number>\d+\.\d+|\d+)|(?<Operator>[\+\-\~\!\*\^\/\√\%\&])|(?<Punctuation>[\(\)])", Match)) {
      loop, % Match.Count() {
        Name := Match.Name(A_Index)
        Value := Match[Name]
        
        if (Match.Len(A_Index)) {
          Tokens.Push({"Type": Name, "Value": Value})
        }
      }
      
      Source := SubStr(Source, Match.Pos(0) + Match.Len(0))
    }
    
    return Tokens
  }
  
  static BinaryPrecedence := {"+": 1, "-": 1, "&": 1, "*": 2, "^": 2, "/": 2, "√": 1, "%": 2}
  
  static UnaryPrecedence := 5
  
  EvaluateExpressionOperand(Tokens) {
    NextToken := Tokens.RemoveAt(1)
    
    if (NextToken.Type = "Punctuation" && NextToken.Value = "(") {
      
      Value := this.EvaluateExpression(Tokens)
      
      NextToken := Tokens.RemoveAt(1)
      
      return Value
    }
    else if (NextToken.Type = "Operator") {
      
      Value := this.EvaluateExpression(Tokens, this.UnaryPrecedence)
      
      switch (NextToken.Value) {
        case "+": {
          return Value
        }
        case "-": {
          return -Value
        }
        case "~": {
          return -Value + 1
        }
        case "√": {
          return ZTrim(Sqrt(Value))
        }
        case "&": {
          GuiControl, Text, Button3, % IsPrime(Value)
          Sleep, 1000
          GuiControl, Text, Button3, IsPr
          return Value
        }
      }
      
      Throw "Unary operator " NextToken.Value " is not implemented"
    }
    else if (NextToken.Type = "Number") {
      
      return NextToken.Value * 1
    }
    
  }
  
  EvaluateExpression(Tokens, Precedence := 0) {
    LeftValue := this.EvaluateExpressionOperand(Tokens)
    
    OperatorToken := Tokens.RemoveAt(1)
    
    while (OperatorToken.Type = "Operator" && this.BinaryPrecedence[OperatorToken.Value] >= Precedence) {
      RightValue := this.EvaluateExpression(Tokens, this.BinaryPrecedence[OperatorToken.Value])
      
      switch (OperatorToken.Value) {
        case "+": {
          LeftValue += RightValue
        }
        case "-": {
          LeftValue -= RightValue
        }
        case "*": {
          LeftValue *= RightValue
        }
        case "/": {
          LeftValue := LeftValue/RightValue
        }
        case "%": {
          LeftValue := Per(LeftValue, RightValue)
        }
        case "^": {
          LeftValue := LeftValue**RightValue
        }
      }
      
      OperatorToken := Tokens.RemoveAt(1)
    }
    
    if (OperatorToken) {
      Tokens.InsertAt(1, OperatorToken)
    }
    
    return ZTrim(LeftValue)
  }
  
  Evaluate(Source) {
    return this.EvaluateExpression(this.Tokenize(Source))
  }
}

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

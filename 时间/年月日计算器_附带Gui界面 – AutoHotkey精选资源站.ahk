Gui, SpanCalc:Add, Text, , Enter Date One:
Gui, SpanCalc:Add, DateTime, vDate1, LongDate
Gui, SpanCalc:Add, Text, , Enter Date Two:
Gui, SpanCalc:Add, DateTime, vDate2, LongDate
Gui, SpanCalc:Add, Button, , Calculate
Gui,SpanCalc:Show, , Calculate How Long

Return

; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=54796

SpanCalcButtonCalculate:
  Gui, Submit, NoHide
  HowLong(Date1,Date2)
  MsgBox, , TimeSpan Calculation, Years %Years%`rMonths %Months%`rDays %Days% %Past%
Return

HowLong(FromDay,ToDay)
  {
   Global Years,Months,Days,Past
   Past := ""

    FromDay := SubStr(FromDay,1,8)
    ToDay := SubStr(ToDay,1,8)

; If two dates identical

   If (ToDay = FromDay)
   {
     Years := 0, Months := 0, Days := 0
     Return
   }
   
 ; Added to swap dates if in reverse order (looking back). The calculation remains the same.

   If (ToDay < FromDay)
   {
     Temp := Today
     ToDay := FromDay
     FromDay := Temp
     Past := "Ago"
   }
   
    Years  := % SubStr(ToDay,5,4) - SubStr(FromDay,5,4) < 0 ? SubStr(ToDay,1,4)-SubStr(FromDay,1,4)-1 
            : SubStr(ToDay,1,4)-SubStr(FromDay,1,4)

     FromYears := Substr(FromDay,1,4)+years . SubStr(FromDay,5,4)

    If (Substr(FromYears,5,2) <= Substr(ToDay,5,2)) and (Substr(FromYears,7,2) <= Substr(ToDay,7,2))
       Months := Substr(ToDay,5,2) - Substr(FromYears,5,2)
    Else If (Substr(FromYears,5,2) < Substr(ToDay,5,2)) and (Substr(FromYears,7,2) > Substr(ToDay,7,2))
       Months := Substr(ToDay,5,2) - Substr(FromYears,5,2) - 1
    Else If (Substr(FromYears,5,2) > Substr(ToDay,5,2)) and (Substr(FromYears,7,2) <= Substr(ToDay,7,2))
       Months := Substr(ToDay,5,2) - Substr(FromYears,5,2) +12
    Else If (Substr(FromYears,5,2) >= Substr(ToDay,5,2)) and (Substr(FromYears,7,2) > Substr(ToDay,7,2))
       Months := Substr(ToDay,5,2) - Substr(FromYears,5,2) +11
 
     If (Substr(FromYears,7,2) <= Substr(ToDay,7,2))
         FromMonth := Substr(ToDay,1,4) . SubStr(ToDay,5,2) . Substr(FromDay,7,2)
     Else If Substr(ToDay,5,2) = "01"
         FromMonth := Substr(ToDay,1,4)-1 . "12" . Substr(FromDay,7,2)
     Else
        FromMonth := Substr(ToDay,1,4) . Format("{:02}", SubStr(ToDay,5,2)-1) . Substr(FromDay,7,2)

    Date1 := Substr(FromMonth,1,6) . "01"
    Date2 := Substr(ToDay,1,6) . "01"
    Date2 -= Date1, Days
    If (Date2 < Substr(FromDay,7,2)) and (Date2 != 0)
        FromMonth := Substr(FromMonth,1,6) . Date2

       ToDay -= %FromMonth% , d
       Days := ToDay
 }

; Enable mousewheel in AutoHotkey GUIs

#If MouseIsOver("ahk_class AutoHotkeyGUI")
   WheelUp::Send {Up}
   WheelDown::Send {Down}
#If

MouseIsOver(WinTitle)
{
   MouseGetPos,,, Win
   Return WinExist(WinTitle . " ahk_id " . Win)
}
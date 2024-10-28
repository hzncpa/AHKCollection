T1 := 19990615
T2 := A_Now

/*
x := ElapsedTime(T1)
MsgBox % "Age / Duration Since " T1 "`n"
. "`n" x.Yr  " Years"
. "`n" x.Mon  " Months"
. "`n" x.Day  " Days"
. "`n" x.Hr  " Hours"
. "`n" x.Min  " Minutes"
. "`n" x.Sec  " Seconds"
*/

x := ElapsedTime(T1, T2)
MsgBox % "您的年龄:`n"
;MsgBox % "Duration between " T1 "`nand " T2 "`n" 
. "`n" x.Yr  " 年"
. "`n" x.Mon  " 月"
. "`n" x.Day  " 天"
. "`n" x.Hr  " 小时"
. "`n" x.Min  " 分钟"
. "`n" x.Sec  " 秒"
Yr := x.Yr
Mon := x.Mon
Day := x.Day
Clipboard = %Yr% Years, %Mon% Months and %Day% Days
return

; https://www.autohotkey.com/boards/viewtopic.php?p=480666&sid=94ddd8bbc466f331b4fa86a027b3a57e#p480666

ElapsedTime(T1, T2:=""){ ; http://www.autohotkey.com/board/topic/119833-elapsed-time-calculator/
  if (T1>T2)
    Tx:=T1,T1:=T2,T2:=Tx,Neg:=1
  FormatTime,T1,%T1%,yyyyMMddHHmmss
  FormatTime,T2,%T2%,yyyyMMddHHmmss
  Yr:=SubStr(T2,1,4)-(Yr1:=SubStr(T1,1,4)),Mon:=SubStr(T2,5,2)-(Mon1:=SubStr(T1,5,2)),Day:=SubStr(T2,7,2)-SubStr(T1,7,2)
  , Hr:=SubStr(T2,9,2)-SubStr(T1,9,2),Min:=SubStr(T2,11,2)-SubStr(T1,11,2),Sec:=SubStr(T2,13,2)-SubStr(T1,13,2),Res:=[]
  if Sec<0
    Sec+=60,Min--
  if Min<0
    Min+=60,Hr--
  if Hr<0
    Hr+=24,Day--
  if Day<0
    Day+=(Mon1~="[469]|11")?30:Mon1=2?(Mod(Yr1,4)?28:29):31,Mon--
  if Mon<0
    Mon+=12,Yr--
  for each,v in StrSplit("Yr,Mon,Day,Hr,Min,Sec",",")
    x:=%v%*(Neg?-1:1),Res[v]:=(T1&&T2)?x:"Error"
  return Res
}
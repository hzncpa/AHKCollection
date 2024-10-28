/*
This DateCalc() function calculates a new date for any StartDate by 
providing Years, Months, and/or Days (+ or -) as parameters.
https://jacks-autohotkey-blog.com/2021/04/01/calculating-dates-in-autohotkey-by-adding-years-months-and-or-days/

Uses the Floor() and Mod() functions to account for months and years.
https://jacks-autohotkey-blog.com/2021/04/12/fake-math-tricks-using-the-floor-and-mod-functions-autohotkey-tips/

August 18, 2021 Added test for valid date when calculated month contains less days than the starting month.
*/

; 对有效日期进行强制测试
起始日期 := "21000331"
年 := 02
月 := 03
日 := 05

if 起始日期 is Date
	新的日期 := DateCalc(起始日期, 年, 月, 日)
 else {
	MsgBox, 不是一个有效的开始日期!
	Return
 }

FormatTime, Start , %起始日期%, LongDate
FormatTime, New , %新的日期%, LongDate

MsgBox,, DateCalc, % Start "`r`r累加:`r`t年：" 年 "`r`t月：" 月 "`r`t日：" 日 "`r`r" New

DateCalc(Date := "",Years := 0,Months := 0,Days := 0) {
	If Date=
		Date := A_Now
	Months := SubStr(Date,5,2)+Months
    , CalcYears := Floor(Months/12) + Years
    , CalcMonths := Mod(Months,12)
	If (CalcMonths <= 0)
		CalcYears := CalcMonths = 0 ? CalcYears-1 : CalcYears
		, CalcMonths := CalcMonths + 12

	NewDate := Substr(Date,1,4)+CalcYears . Format("{:02}", CalcMonths) . Substr(Date,7,2)
/*
; Check for valid date
	FormatTime, TestDate, %NewDate%, ShortDate
	While !TestDate
	{
		NewDate := Substr(Date,1,4)+Years
		. Format("{:02}", Months)
		. Substr(Date,7,2)-A_Index
		
		FormatTime, TestDate, %NewDate%, ShortDate
	}
*/

; 检查三种可能的月份长度的有效日期
	Loop, 3 {
		if NewDate is not Date
			NewDate := Substr(Date,1,4)+Years . Format("{:02}", Months) . Substr(Date,7,2)-A_Index
		Else
			Break
	}

	NewDate += Days , Days
	Return NewDate
}

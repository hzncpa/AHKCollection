; 自带指令直接返回星期几
; FormatTime, 返回星期几, 20230112, dddd
FormatTime, 返回星期几, %A_YYYY%%A_MM%%A_DD%, dddd
MsgBox %返回星期几%

; https://www.autoahk.com/archives/42214
; 按 年、月 范围输出全部日期
; AutoDate(2022)--按格式输出2022年所有天数
; AutoDate(20221)--按格式输出2022年1月所有天数
; 第一个参数为日期范围，可以是 年（2022）、月（202211）、日（20221122），也可以留空，为当前日期
; 默认输出格式 ： 年月日-星期。。参二可以自定义格式：同FormatTime相同
MsgBox % "比如这样`n2011年1月`n`n" AutoDate(20111)

; MsgBox % "指定某一天：" AutoDate(20230112)

AutoDate(LongDate := "", DateFormat := "yyyy年MM月dd日-dddd"){
	If !(LongDate)
		LongDate := A_Now
	If (RegExMatch(LongDate,"[^\d]")){
		MsgBox 请输入正确的待格式化日期格式：`n2000/200010/20001010
		Return 
	}
	InTime := LongDate
	FormatTime, OutTime, % LongDate, yyyyMMdd
	Out := OutTime
	LongDate += -1, days
	Loop {
		LongDate += 1, days
		FormatTime, AutoTime, % LongDate, % DateFormat
		FormatTime, OutTime, % LongDate, yyyyMMdd
		If (RegExMatch(InTime, "^\d{4}$"))
			If (RegExReplace(Out,"^(\d{4}).+$","$1") != RegExReplace(OutTime,"^(\d{4}).+$","$1"))
				Break
		If (RegExMatch(InTime, "^\d{5,6}$"))
			If (RegExReplace(Out,"^\d{4}(\d{2}).+$","$1") != RegExReplace(OutTime,"^\d{4}(\d{2}).+$","$1"))
				Break
		If (RegExMatch(InTime, "^\d{7,}$") | !(LongDate))
			If (RegExReplace(Out,"^\d{6}(\d{2}).+$","$1") != RegExReplace(OutTime,"^\d{6}(\d{2}).+$","$1"))
				Break
		RDate .= "`n" AutoTime
	}
	Return Trim(RDate,"`n")
}
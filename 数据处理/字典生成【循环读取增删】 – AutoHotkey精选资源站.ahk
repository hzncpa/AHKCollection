Str=
(
File name : 2.jpg
File size : 1741456 bytes
File date : 2021:12:13 08:54:29
Camera make : HUAWEI
Camera model : PCT-AL10
Date/Time : 2021:09:18 14:07:51
Resolution : 4000 x 3000
Flash used : No
Focal length : 4.8mm (35mm equivalent: 101mm)
Exposure time : 0.0100 s (1/100)
Aperture : f/1.8
ISO equiv. : 80
Whitebalance : Auto
Light Source : Daylight
Metering Mode : pattern
Exposure : program (auto)
GPS Latitude : N 28d 39m 24.855194s
GPS Longitude : F 121d 23m 14.384765s
GPS Altitude : -0.00m
JPEG Quality : 96
)

名称:={}

Loop, Parse, Str, `n, `r
{
    左右分割符列数 := StrSplit(A_LoopField, " : ")
    名称[左右分割符列数[1]] := 左右分割符列数[2]
}
MsgBox % 名称["GPS Latitude"]


; =============== 方法二：复杂写法 ===============
Loop, Parse, Str, `n, `r
{
    左右分割符列数 := InStr(A_LoopField, " : ")
    名称[SubStr(A_LoopField, 1, 左右分割符列数-1)] := SubStr(A_LoopField, 左右分割符列数+3, StrLen(A_LoopField))
}
MsgBox % 名称["GPS Latitude"]

; =============== 嵌套数组_查询数据的简写 ===============
被查询人姓名 := "王五"

; 嵌套数组的数据
姓名 := {"张三":1, "李四":2, "王五":3, "赵六":4}
性别 := ["男", "女", "女", "男"]
年龄 := ["18", "26", "32", "20"]

MsgBox % "姓名：" 被查询人姓名 "`n性别：" 性别[姓名[被查询人姓名]] "`n年龄：" 年龄[姓名[被查询人姓名]]
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

����:={}

Loop, Parse, Str, `n, `r
{
    ���ҷָ������ := StrSplit(A_LoopField, " : ")
    ����[���ҷָ������[1]] := ���ҷָ������[2]
}
MsgBox % ����["GPS Latitude"]


; =============== ������������д�� ===============
Loop, Parse, Str, `n, `r
{
    ���ҷָ������ := InStr(A_LoopField, " : ")
    ����[SubStr(A_LoopField, 1, ���ҷָ������-1)] := SubStr(A_LoopField, ���ҷָ������+3, StrLen(A_LoopField))
}
MsgBox % ����["GPS Latitude"]

; =============== Ƕ������_��ѯ���ݵļ�д ===============
����ѯ������ := "����"

; Ƕ�����������
���� := {"����":1, "����":2, "����":3, "����":4}
�Ա� := ["��", "Ů", "Ů", "��"]
���� := ["18", "26", "32", "20"]

MsgBox % "������" ����ѯ������ "`n�Ա�" �Ա�[����[����ѯ������]] "`n���䣺" ����[����[����ѯ������]]
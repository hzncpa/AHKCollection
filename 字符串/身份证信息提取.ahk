;v1 ;{{{
#Requires AutoHotkey <=2.0 ;v1
#SingleInstance Force  ;v1
re_index(){
FileGetTime last_user, %A_ScriptFullPath%, M ;v1
if ( A_now-last_user<1.5 )
		reload
}
SetKeyDelay 0
SetMouseDelay 0
settimer re_index,1000
 ;}}}





身份证 = 32011219970911001X
MsgBox % 身份证校验(身份证)

/*      下面这段由飞跃群分享
MsgBox % 18位身份证校验码(身份证)

18位身份证校验码(身份证) {
  if (StrLen(身份证)<17)  ;校验码计算需要身份证前17位
    return
  Loop, 17
    累和+=SubStr(身份证,A_Index,1)*Mod(1<<(18-A_Index),11)
  return SubStr("10X98765432", Mod(累和,11)+1, 1)
}
*/

身份证校验(ID) {
  省=
  (
  ,,,,,,,,,,
  北京市,天津市,河北省,山西省,内蒙古自治区,,,,,,
  辽宁省,吉林省,黑龙江省,,,,,,,,
  上海市,江苏省,浙江省,安徽省,福建省,江西省,山东省,,,,
  河南省,湖北省,湖南省,广东省,广西壮族自治区,海南省,,, 
  重庆市,四川省,贵州省,云南省,西藏自治区,,,,,,,
  陕西省,甘肃省,青海省,宁夏回族自治区,新疆维吾尔自治区
  )
  地址:=StrSplit(省,",")[substr(ID,1,2)]
  性别:=Mod(substr(ID,-1,1),2) ? "男" : "女" 
  出生:=substr(ID,7,8)
  EnvSub, 出生, %a_now%, days
  年龄 := 出生<0 ? substr(a_now,1,4)-substr(ID,7,4)+1 : ""
  Loop,Parse,% "7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2",`,
    Sum:=A_LoopField*SubStr(ID, a_index, 1)+(a_index=1 ? 0 : Sum)
  Return SubStr("10x98765432", Mod(Sum,11)+1, 1)=SubStr(ID, 0) and 年龄 and 地址 
          ? 地址 年龄 "岁" 性别 : "号码错误"
}

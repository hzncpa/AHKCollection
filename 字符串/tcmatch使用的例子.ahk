;#Requires AutoHotkey >=2.0 ;修改ahk版本
re_index(){
FileGetTime last_user, %A_ScriptFullPath%, M ;v1
;last_user:=filegettime(A_scriptfullpath) ;v2
if ( A_now-last_user<1.5 )
		reload
}
searchstr:="cs h"
sn_cache:=["测试好","哈哈","测试"]
  list := ""
  for k, itemName in sn_cache
  {
    ; 支持 “a b” 匹配 “acdbef”
    for k, v in StrSplit(SearchStr, " ")
			if (!tcmatch(itemName, v))
				continue, 2
    
    list .= "|" itemName
  }
msgbox % list
;msgbox % tcmatch("测试","cs")

TCMatchOn(dllPath = "") {
    if(g_TCMatchModule)
        return g_TCMatchModule
	g_TCMatchModule := DllCall("LoadLibrary", "Str", dllPath, "Ptr")
    return g_TCMatchModule
}

TCMatchOff() {
    DllCall("FreeLibrary", "Ptr", g_TCMatchModule)
    g_TCMatchModule := ""
}

TCMatch(aHaystack, aNeedle) {
	global
	static  g_TCMatchModule
	 ;64 or 32
	 ;MatchFileW := (A_PtrSize == 8 ) ? "TCMatch64\MatchFileW" : "TCMatch\MatchFileW"
	 ;dllPath := A_ScriptDir "\Lib\tcmatch\" ((A_PtrSize == 8 ) ? "TCMatch64" : "TCMatch") ".dll"
	 ;32
	 envget softdir,softdir
	 envget commander_path,commander_path
	 matchfilew:=(softdir!="")?Softdir "\tc\TCMatch\MatchFileW":commander_path "\TCMatch\MatchFileW"
	 dllPath:=(Softdir!="")?Softdir "\tc\tcmatch.dll":Commander_path "\tcmatch.dll"
	g_TCMatchModule := TCMatchOn(dllPath)
    Return DllCall(MatchFileW, "WStr", aNeedle, "WStr", aHaystack)
}



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
	static MatchFileW, g_TCMatchModule
	MatchFileW := (A_PtrSize == 8 ) ? "TCMatch64\MatchFileW" : "TCMatch\MatchFileW"
	SplitPath A_AhkPath,, OutDir
	dllPath := OutDir "\Lib\tcmatch\" ((A_PtrSize == 8 ) ? "TCMatch64" : "TCMatch") ".dll"
	g_TCMatchModule := TCMatchOn(dllPath)
    Return DllCall(MatchFileW, "WStr", aNeedle, "WStr", aHaystack)
}
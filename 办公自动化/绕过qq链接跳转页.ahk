; 适用于新版qqnt，启动后在qq聊天里点击链接时可获取链接地址，跳过qq的跳转页面
#HotIf GetQQLinkUnderMouse() && A_Cursor == "Unknown"
LButton:: Run(GetQQLinkUnderMouse.LastFound)
#HotIf

GetQQLinkUnderMouse() {
    A_CoordModeMouse := "Screen"
    MouseGetPos(&x, &y, &hwnd)
    if WinExist("QQ ahk_class Chrome_WidgetWin_1 ahk_exe QQ.exe ahk_id " hwnd) {
        uia := ComObject("{E22AD333-B25F-460C-83D0-0581107395C9}", "{AAE072DA-29E3-413D-87A7-192DBF81ED10}")
        ComCall(7, uia, "int64", x | y << 32, "ptr*", ele := ComValue(13, 0))
        if ele.Ptr {
            ComCall(23, ele, "ptr*", &nameBstr := 0)
            if nameBstr {
                name := StrGet(nameBstr)
                DllCall("OleAut32\SysFreeString", "ptr", nameBstr)
                if name ~= "^(?:(?:(?:ht|f)tps?):\/\/)?(?:[^!@#$%^&*?.\s-](?:[^!@#$%^&*?.\s]{0,63}[^!@#$%^&*?.\s])?\.)+[a-z]{2,6}\/?" {
                    GetQQLinkUnderMouse.LastFound := name
                    return true
                }
            }
        }
    }
}
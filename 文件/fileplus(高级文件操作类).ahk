;===============
;文件高级操作类-来之Autohotkey中文社区https://www.autoahk.com/archives/18616
;===============
;方法 Explorer_GetPath(hwnd="")--获取当前管理器路径
;方法 Explorer_GetAll(hwnd="")--获取管理器目录
;方法 Explorer_GetSelected(hwnd="")--获取管理器已选择文件目录
;方法 Explorer_GetWindow(hwnd="")获取管理器窗口名字
;方法 Explorer_Get(hwnd="",selection=false)获取管理器目录获取
;方法 File_OpenAndSelect(path, selfilearr) --打开并选中文件
;方法 Files_OpenAndSelect(path, selfilearr) --打开并选中一个或多个文件

;历史
;2021-01-21 修复夹带16进制的bug

;示例
myfile:=New fileplus
F9::
    path := myfile.Explorer_GetPath()
    ;all := myfile.Explorer_GetAll()
    ;sel := myfile.Explorer_GetSelected()
    MsgBox % path
    ;MsgBox % all
    ;MsgBox % sel
    ;myfile.File_OpenAndSelect("E:\lenovo\Pictures\随机选中的样例.png") ;更换为自己的路径
    ;myfile.Files_OpenAndSelect("E:\lenovo\Pictures",["随机选中的样例.png","#ClipboardTimeout备注的解释.png"]) ;更换为自己的路径
return
;类
Class FilePlus
{

    ;方法 Explorer_GetWindow(hwnd="")获取管理器窗口名字
    ;参数hwnd 

    Explorer_GetWindow(hwnd="")
    {
       ; thanks to jethrow for some pointers here
        WinGet, process, processName, % "ahk_id" hwnd := hwnd? hwnd:WinExist("A")
        WinGetClass class, ahk_id %hwnd%
     
       if (process!="explorer.exe")
          return
       if (class ~= "(Cabinet|Explore)WClass")
       {
          for window in ComObjCreate("Shell.Application").Windows
             if (window.hwnd==hwnd)
                return window
       }
       else if (class ~= "Progman|WorkerW")
          return "desktop" ; desktop found
    }
    
    ;方法 Explorer_Get(hwnd="",selection=false)获取管理器目录获取
    ;参数hwnd 
    ;参数selection 布尔类型
    
    Explorer_Get(hwnd="",selection=false)
    {
       if !(window := this.Explorer_GetWindow(hwnd))
          return ErrorLevel := "ERROR"
       if (window="desktop")
       {
          ControlGet, hwWindow, HWND,, SysListView321, ahk_class Progman
          if !hwWindow ; #D mode
             ControlGet, hwWindow, HWND,, SysListView321, A
          ControlGet, files, List, % ( selection ? "Selected":"") "Col1",,ahk_id %hwWindow%
          base := SubStr(A_Desktop,0,1)=="" ? SubStr(A_Desktop,1,-1) : A_Desktop
          Loop, Parse, files, `n, `r
          {
             path := base "" A_LoopField
             IfExist %path% ; ignore special icons like Computer (at least for now)
                ret .= path "`n"
          }
       }
       else
       {
          if selection
             collection := window.document.SelectedItems
          else
             collection := window.document.Folder.Items
          for item in collection
             ret .= item.path "`n"
       }
       return Trim(ret,"`n")
    }
    ;方法 Explorer_GetPath(hwnd="")--获取当前管理器路径
    ;参数hwnd 
    ;示例path:=Explorer_GetPath()
    
    Explorer_GetPath(hwnd="")
    {
       if !(window := this.Explorer_GetWindow(hwnd))
          return ErrorLevel := "ERROR"
       if (window="desktop")
          return A_Desktop
       path := window.LocationURL
       path := RegExReplace(path, "ftp://.*@","ftp://")
       StringReplace, path, path, file:///
       StringReplace, path, path, /,\, All
       ; thanks to polyethene、紧急制动（反馈）
       Loop
          If RegExMatch(path, "i)(?<=%)[\da-f]{1,2}", hex)
            StringReplace, path, path,`%%hex%, % Chr("0x" . hex), All
          Else Break
       return path
    }
    ;方法 Explorer_GetAll(hwnd="")--获取管理器目录
    ;参数hwnd 
    Explorer_GetAll(hwnd="")
    {
       return this.Explorer_Get(hwnd)
    }
    ;方法 Explorer_GetSelected(hwnd="")--获取管理器已选择文件目录
    ;参数hwnd 
    Explorer_GetSelected(hwnd="")
    {
       return this.Explorer_Get(hwnd,true)
    }
    
    
    
    ;方法 File_OpenAndSelect(sFullPath) --打开目录并选中文件
    ;参数sFullPath 类型字符串
    ;示例File_OpenAndSelect("E:\Documents\Desktop\ts1.ahk")

    File_OpenAndSelect(sFullPath)
    {
        SplitPath sFullPath, , sPath
        ;MsgBox,% sPath
        FolderPidl := DllCall("shell32\ILCreateFromPath", "Str", sPath)
        ;MsgBox,% FolderPidl
        DllCall("shell32\SHParseDisplayName", "str", sFullPath, "Ptr", 0, "Ptr*", ItemPidl := 0, "Uint", 0, "Uint*", 0)
        DllCall("shell32\SHOpenFolderAndSelectItems", "Ptr", FolderPidl, "UInt", 1, "Ptr*", ItemPidl, "Int", 0)
        this.CoTaskMemFree(FolderPidl)
        this.CoTaskMemFree(ItemPidl)
    }
    Files_OpenAndSelect(path,selfilearr) 
    {
        FolderPidl := DllCall("shell32\ILCreateFromPath", "Str", path)
        VarSetCapacity(plist,selfilearr.Length() * A_PtrSize)
        pidls := []
        Loop % selfilearr.Length()
        {
            ItemPidl := DllCall("shell32\ILCreateFromPath", "Str", InStr(selfilearr[A_Index], ":") ? selfilearr[A_Index] : path "\" selfilearr[A_Index])
            if (ItemPidl)
            {
                pidls.Push(ItemPidl)
                NumPut(ItemPidl, plist, (A_Index-1 ) * A_PtrSize,"ptr")
            }
        }
        DllCall("shell32\SHOpenFolderAndSelectItems", "Ptr", FolderPidl, "UInt", pidls.Length(), "Ptr",&plist, "Int", 0)
        
        this.CoTaskMemFree(FolderPidl)
        Loop % pidls.Length()
        {
            this.CoTaskMemFree(pidls[A_Index])
        }            
    }
    CoTaskMemFree(pv) 
    {
       Return   DllCall("ole32\CoTaskMemFree", "Ptr", pv)
    }
}
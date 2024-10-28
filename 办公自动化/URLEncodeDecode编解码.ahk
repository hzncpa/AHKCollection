url := "WinWait%2C+ahk_class+IEFrame%0D%0AWinSet%2C+AlwaysOnTop+%2C+On%2C+ahk_class+IEFrame%0D%0Aif+%28%E4%BB%8A%E6%97%A5%E6%96%B0%E9%97%BB%E5%B7%B2%E6%9B%B4%E6%96%B0%3D1%29%0D%0A%09WinMove%2C+ahk_class+IEFrame%2C+%2C1%2C1%2C595%2C710%0D%0A++else+if+%28%E4%BB%8A%E6%97%A5%E6%96%B0%E9%97%BB%E5%B7%B2%E6%9B%B4%E6%96%B0%3D2%29%0D%0A%09WinMove%2C+ahk_class+IEFrame%2C+%2C1%2C1%2C595%2C710+%3B+%E5%BE%85%E5%AE%9A%0D%0ASleep+1500%0D%0A%0D%0A%3B%E7%AC%AC%E4%B8%80%E4%B8%AA%E6%98%AF%E6%96%B0%E6%88%AA%E5%8F%96%EF%BC%8C%E7%AC%AC%E4%BA%8C%E4%B8%AA%E6%98%AF%E8%80%81%E7%89%88%0D%0A%E5%B1%95%E5%BC%80%3A%3D%22%7C%3C%3E*209%2415.TU3wYJYWdyTYXMYAcY%7C%3C%3E*223%2416.001yz7zwTaVyzbxcTYVvm000U%22%0D%0A%E6%B3%A8%E5%86%8C%E7%99%BB%E5%BD%95%3A%3D%22%7C%3C%3E*200%2437.WBU00zDys00TcbQ00Dlzy00Dx9r003x4jU00wjzU00zk%22%0D%0ALoop+%7B%0D%0A%09if+%28ok%3A%3DFindText%280%2C+0%2C+1920%2C+1080%2C+0%2C+0%2C+%E5%B1%95%E5%BC%80%2C+%2C0%29%29+%7B%0D%0A%09%09X%3A%3Dok.1.x%2C+Y%3A%3Dok.1.y%2C+Comment%3A%3Dok.1.id%0D%0A%09%09Click%2C+%25X%25%2C+%25Y%25%0D%0A%09%09Break%0D%0A%09%7D+else+if+%28ok%3A%3DFindText%280%2C+0%2C+1920%2C+1080%2C+0%2C+0%2C+%E6%B3%A8%E5%86%8C%E7%99%BB%E5%BD%95%2C+%2C0%29%29+%7B%0D%0A%09%09Gosub+%E9%87%8D%E6%96%B0%E7%99%BB%E5%BD%95%E5%BE%AE%E5%8D%9A%0D%0A%09%09Break%0D%0A%09%7D%0D%0A%09Sleep+500%0D%0A%7D%0D%0A%0D%0ASleep+5000%0D%0A%0D%0AShape+%3A%3D+GetCursorShape%28%29%0D%0AToolTip+%25+%22%E7%89%B9%E5%BE%81%E7%A0%81%EF%BC%9A%22+Shape%0D%0ASleep+2000%0D%0AToolTip%0D%0A%0D%0ALoop+%7B%0D%0A%E5%85%89%E6%A0%87%E7%89%B9%E5%BE%81%E7%A0%81+%3A%3D+GetCursorShape%28%29%0D%0A%09if+%28%E5%85%89%E6%A0%87%E7%89%B9%E5%BE%81%E7%A0%81%3D2616319428%29%0D%0A%09%09Break%0D%0A%09else+%7B%0D%0A%09%09MouseGetPos%2C+X%2C+Y%0D%0A%09%09MouseMove%2C+%25X%25+%2C+%25+Y%2B10%2C+0%0D%0A%09%09%7D%0D%0A%09Sleep+200%0D%0A%7D%09"


decoded := EncodeDecodeURI(url, false)
encoded := EncodeDecodeURI(decoded)
msgbox,-------------------------------------------------`nDECODED=`n%decoded%`n-------------------------------------------------`nENCODED=`n%encoded%`n-------------------------------------------------
return

; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=84825
EncodeDecodeURI(str, encode := true, component := true) {          ; By teadrinker
   static Doc, JS
   StringReplace, str, str, +, %A_Space%, All ; È¥Á¬½Ó·û
   if !Doc {
      Doc := ComObjCreate("htmlfile")
      Doc.write("<meta http-equiv=""X-UA-Compatible"" content=""IE=9"">")
      JS := Doc.parentWindow
      ( Doc.documentMode < 9 && JS.execScript() )
   }
   Return JS[ (encode ? "en" : "de") . "codeURI" . (component ? "Component" : "") ](str)
}
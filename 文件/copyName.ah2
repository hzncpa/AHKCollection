sleep 100
SplitPath A_Args[1], &name, &dir, &ext, &name_no_ext, &drive
A_clipboard:=""
A_clipboard:=name_no_ext?name_no_ext:A_Clipboard
sleep 200
exitapp

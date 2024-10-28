#Persistent
iconpath:=""
F3::
InputBox,a
FileCreateShortcut,%Clipboard%,%A_Desktop%\%a%.lnk,,,%iconpath%
return

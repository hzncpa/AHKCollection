myEnv:={}
arr:=["appdata","Softdir","COMMANDER_PATH","Temp","OneDrive","UserProfile","ProgramData","SystemRoot"]
str:=""
PostMessage 1075,2018, 0, ,"ahk_class TTOTAL_CMD"
sleep 200
for k,v in arr
	myEnv.%v%:=envget(v)

;单独修正一些错误
myEnv.Softdir:="D:\Softdir"

for k,v in myEnv.ownprops()
	{
	if instr(A_clipboard,v)
		str:=strreplace(A_clipboard,v,"%" k "%")
	}
A_clipboard:=str
exitapp

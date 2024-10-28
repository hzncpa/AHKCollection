; https://autohotkey.com/boards/viewtopic.php?f=6&t=24202
; Note: Does not work with Windows XP due to lack of 'wlan' sub-context (nor 'export')
; Should work with Windows Vista onwards but only test with Windows 10

#SingleInstance force ; Force only one instance at a time#SingleInstance force

; Prompt to 'Run as Admin', i.e. show UAC dialog
If Not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"  ; Requires v1.0.92.01+
   ExitApp
}

; ***** Housekeeping *****
SetWorkingDir, %A_ScriptDir%
FilesDir=%A_ScriptDir%\WifiXMLS

IfNotExist,%FilesDir%
  FileCreateDir,%FilesDir%
  
FileDelete, %FilesDir%\*.xml        ; Make sure there are no existing XML files
IfExist Results.txt                 ; Make sure there is no existing Results.txt file
    FileDelete, Results.txt    

FileAppend, Stored WiFi passwords are as follows:`n`n, Results.txt ; Create first line of new Results.txt file

; ***** Export profiles *****
RunWait, %comspec% /c "netsh wlan export profile folder=%FilesDir% key=clear",, hide  ; Exports all WiFi profiles

; ***** Loop through/parse generated files *****

FileList =  ; Initialize to be blank
Loop, %FilesDir%\*.xml ; Loop through the XML files
    FileList = %FileList%%A_LoopFileName%`n ; Generate a filelist
Sort, FileList, ; Sort the filelist alphabetically

Loop, %FilesDir%\*.xml              ; Loop through each file
{
  string:=""                        ; Store contents of file in variable
  xmlfile:=A_LoopFileFullPath       ; With each file, with its path
  FileRead, string, %xmlfile%       ; ... read each file into memory
  Loop, parse, string, `n, `r       ; Parse each line using LineFeed (`n) and Carriage Return (`r)
   {
   lines:= A_LoopField  `           ; Store lines in variable
   if lines contains <name>         ; Check lines for 1st criteria
      {
      L%a_index%:=RegExReplace( lines, "<.*?>" )
      ssid:= % L%a_index%           ; Store search result in variable
      }
       
   if lines contains <authentication>   ; Check lines for 2nd criteria
      {
      L%a_index%:=RegExReplace( lines, "<.*?>" )
      auth:= % L%a_index%           ; Store search result in variable
      }

   if lines contains <encryption>   ; Check lines for 3rd criteria
       {
       L%a_index%:=RegExReplace( lines, "<.*?>" )
       crypt:= % L%a_index%         ; Store search result in variable
       }

   if lines contains <keyMaterial>  ; Check lines for 4th criteria
      {
      L%a_index%:=RegExReplace( lines, "<.*?>" )
      password:= % L%a_index%       ; Store search result in variable
      
      ssid=%ssid%                   ; Keep just the data between <name> and </name>
      auth=%auth%                   ; Keep just the data between <authentication> and </authentication>
      crypt=%crypt%                 ; Keep just the data between <encryption> and </encryption>
      password=%password%           ; Keep just the data between <keyMaterial> and </keyMaterial>
       
      resultbasic .= "XML profile:"A_Tab . xmlfile . "`nSSID:"A_Tab A_Tab . ssid "`nPassword:"A_Tab . password . "`n---------------------------------------------`n"
      resultverbose .= "XML profile:"A_Tab . xmlfile . "`nSSID:"A_Tab A_Tab . ssid "`nPassword:"A_Tab . password . "`nAuthentication:"A_Tab . auth . "`nEncryption:"A_Tab . crypt . "`n---------------------------------------------`n"
      ; Break                         ; Used for testing
      }
   }
}

; ***** Display a message box, with custom button names, offering a choice of info *****
SetTimer, ChangeButtonNames, 50 
MsgBox, 36, WiFi Profile Info, What info would you like?`n`nBasic, i.e. show just passwords`nVerbose, i.e. show passwords and security`n`nChoose a button...

IfMsgBox, YES 
   {
   FileAppend, %resultbasic%, results.txt   ; Write the basic results to the text file
   FileAppend, `nNote: Only wireless access points with passwords are listed above.`n, Results.txt ; Create last line of new Results.txt file
   Run, results.txt                    ; Open the file in whatever app is registered to display text files
   ExitApp         ; Exit the script
   }
else 
   {
   FileAppend, %resultverbose%, results.txt   ; Write the verbose results to the text file
   FileAppend, `nNote: Only wireless access points with passwords are listed above.`n, Results.txt ; Create last line of new Results.txt file
   Run, results.txt                    ; Open the file in whatever app is registered to display text files
   ExitApp         ; Exit the script
   }
return 

ChangeButtonNames: 
IfWinNotExist, WiFi Profile Info
    return  ; Keep waiting.
SetTimer, ChangeButtonNames, off 
WinActivate 
ControlSetText, Button1, &Basic 
ControlSetText, Button2, &Verbose 
return

Esc::ExitApp    ; Used to cancel the MsgBox, if needed
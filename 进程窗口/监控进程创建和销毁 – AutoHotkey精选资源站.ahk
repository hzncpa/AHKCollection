; By Tebayaki
#Persistent
SWbemServices := ComObjGet("winmgmts:")

SWbemSink := ComObjCreate("WbemScripting.SWbemSink")
ComObjConnect(SWbemSink, "SWbemSink_")

SWbemServices.ExecNotificationQueryAsync(SWbemSink, "Select * from __InstanceCreationEvent within 0.3 where TargetInstance isa 'Win32_Process'")
Return

SWbemSink_OnObjectReady(wbemObject, wbemAsyncContext, wbemSink) {
  Process := wbemObject.TargetInstance ; https://learn.microsoft.com/en-us/windows/win32/cimwin32prov/win32-process
  ToolTip, % Process.Name "`n"
}
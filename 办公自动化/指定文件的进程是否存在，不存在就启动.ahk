CheckProcess("C:\Program Files (x86)\Tencent\QQ\Bin\qq.exe")

CheckProcess(ProcessPath){
  SplitPath, ProcessPath, name, dir, ext, name_no_ext, drive
  if name {
    Process,Exist,%name%
    if !ErrorLevel {
      try {
        Run *RunAs "%ProcessPath%" /restart
        if (ErrorLevel = "ERROR")
          MsgBox 启动失败！
      } catch e {
        MsgBox % e.Extra
      }
    } Else
      Process,Close,%name%
  } Else
    MsgBox 进程路径格式有误！
}
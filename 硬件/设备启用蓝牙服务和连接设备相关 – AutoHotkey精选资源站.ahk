; 代码片段示例1：
; https://www.autohotkey.com/boards/viewtopic.php?p=404352#p404352
deviceName := "jbl clip 3"

DllCall("LoadLibrary", "str", "Bthprops.cpl", "ptr")
toggle := toggleOn := 1
VarSetCapacity(BLUETOOTH_DEVICE_SEARCH_PARAMS, 24+A_PtrSize*2, 0)
NumPut(24+A_PtrSize*2, BLUETOOTH_DEVICE_SEARCH_PARAMS, 0, "uint")
NumPut(1, BLUETOOTH_DEVICE_SEARCH_PARAMS, 4, "uint")  ; fReturnAuthenticated
VarSetCapacity(BLUETOOTH_DEVICE_INFO, 560, 0)
NumPut(560, BLUETOOTH_DEVICE_INFO, 0, "uint")
loop {
  If (A_Index = 1) {
    foundedDevice := DllCall("Bthprops.cpl\BluetoothFindFirstDevice", "ptr", &BLUETOOTH_DEVICE_SEARCH_PARAMS, "ptr", &BLUETOOTH_DEVICE_INFO, "ptr")
    if !foundedDevice
    {
      msgbox 没有蓝牙设备
      return
    }
  } else {
    if !DllCall("Bthprops.cpl\BluetoothFindNextDevice", "ptr", foundedDevice, "ptr", &BLUETOOTH_DEVICE_INFO) {
      msgbox 没有找到
      break
    }
  }
  if (StrGet(&BLUETOOTH_DEVICE_INFO+64) = deviceName) {
    VarSetCapacity(Handsfree, 16)
    DllCall("ole32\CLSIDFromString", "wstr", "{0000111e-0000-1000-8000-00805f9b34fb}", "ptr", &Handsfree)  ; https://www.bluetooth.com/specifications/assigned-numbers/service-discovery/
    VarSetCapacity(AudioSink, 16)
    DllCall("ole32\CLSIDFromString", "wstr", "{0000110b-0000-1000-8000-00805f9b34fb}", "ptr", &AudioSink)
    loop {
      hr := DllCall("Bthprops.cpl\BluetoothSetServiceState", "ptr", 0, "ptr", &BLUETOOTH_DEVICE_INFO, "ptr", &Handsfree, "int", toggle)  ; voice
      if (hr = 0) {
        if (toggle = toggleOn)
          break
        toggle := !toggle
      }
      if (hr = 87)
        toggle := !toggle
    }
    loop {
      hr := DllCall("Bthprops.cpl\BluetoothSetServiceState", "ptr", 0, "ptr", &BLUETOOTH_DEVICE_INFO, "ptr", &AudioSink, "int", toggle)  ; music
      if (hr = 0) {
        if (toggle = toggleOn)
          break 2
        toggle := !toggle
      }
      if (hr = 87)
        toggle := !toggle
    }
  }
}
DllCall("Bthprops.cpl\BluetoothFindDeviceClose", "ptr", foundedDevice)
msgbox 完成
ExitApp

; 代码片段示例2：
deviceName := "jbl clip 3"

DllCall("LoadLibrary", "str", "ws2_32.dll", "ptr")
VarSetCapacity(WSADATA, 394 + (A_PtrSize - 2) + A_PtrSize, 0)
DllCall("ws2_32\WSAStartup", "ushort", 0x0202, "ptr", &WSADATA)
size := 1024
VarSetCapacity(WSAQUERYSETW, size, 0)
NumPut(size, WSAQUERYSETW, 0, "uint")
NumPut(NS_BTH := 16, WSAQUERYSETW, A_PtrSize*5, "uint")
DllCall("ws2_32\WSALookupServiceBeginW", "ptr", &WSAQUERYSETW, "uint", LUP_CONTAINERS := 0x0002, "ptr*", lphLookup)
loop {
  if (DllCall("ws2_32\WSALookupServiceNextW", "ptr", lphLookup, "uint", 0x0002|0x0010|0x0100, "uint*", size, "ptr", &WSAQUERYSETW) = -1) {  ; LUP_CONTAINERS|LUP_RETURN_NAME|LUP_RETURN_ADDR
    error := DllCall("ws2_32\WSAGetLastError")
    if (error = 10110)  ; WSA_E_NO_MORE https://docs.microsoft.com/en-us/windows/win32/winsock/windows-sockets-error-codes-2
      msgbox 找不到设备
    else
      msgbox % "error：" error
    exitapp
  }
  
  if (strget(numget(WSAQUERYSETW, A_PtrSize)) = deviceName) {
    socket := DllCall("ws2_32\socket", "int", AF_BTH := 32, "int", SOCK_STREAM := 1, "int", BTHPROTO_RFCOMM := 3)
    VarSetCapacity(SOCKADDR_BTH, 36, 0)
    NumPut(AF_BTH := 32, SOCKADDR_BTH, 0, "ushort")
    DllCall("RtlMoveMemory", "ptr", &SOCKADDR_BTH+2, "ptr", numget(numget(WSAQUERYSETW, A_PtrSize*12)+0, A_PtrSize*2)+2, int, 6)  ; lpcsaBuffer.RemoteAddr.lpSockaddr.BLUETOOTH_ADDRESS_STRUCT
    DllCall("ole32\CLSIDFromString", "wstr", "{00000003-0000-1000-8000-00805F9B34FB}", "ptr", &SOCKADDR_BTH+16)  ; RFCOMM
    loop 10 {
      DllCall("ws2_32\connect", "int", socket, "ptr", &SOCKADDR_BTH, "int", 36)
      sleep 1500
    }
    DllCall("ws2_32\closesocket", "int", socket)
    DllCall("ws2_32\WSALookupServiceEnd", "ptr", lphLookup)
    break
  }
}
msgbox done
ExitApp
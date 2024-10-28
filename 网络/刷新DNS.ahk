MsgBox % FlushDNS()

; =============================================================================
; Flush entire DNS cache, same as [ipconfig /flushdns] in cmd console
; =============================================================================

FlushDNS() {
  if !(DllCall("dnsapi.dll\DnsFlushResolverCache"))
    throw Exception("DnsFlushResolverCache", -1)
  return 1
}
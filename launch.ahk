#include <mustExec>
debug.init({console: true})
; path := GetFullPathName("main.ahk")
; debug.print("Path of main.ahk: " path)
; while WinExist(path " ahk_class AutoHotkey")
; 	WinKill %path% ahk_class AutoHotkey
; sleep 500
; run taskkill /IM "autohotkeyu64.exe" /F
Run schtasks /run /tn "Servers\DiscoBot"
; Run main.ahk
ExitApp

#include <debug>
#include <functionsahkshouldfuckinghave>
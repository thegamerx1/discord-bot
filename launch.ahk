#include <mustExec>
debug.init({console: true})
path := GetFullPathName("main.ahk")
debug.print("Path of main.ahk: " path)
WinClose %path% ahk_class AutoHotkey
WinWaitClose
Run schtasks /run /tn "Servers\Discobot"
Run main.ahk
ExitApp

#include <debug>
#include <functionsahkshouldfuckinghave>
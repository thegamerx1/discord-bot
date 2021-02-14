#include <mustExec>
debug.init({console: true})
path := GetFullPathName("main.ahk")
debug.print("Path of main.ahk: " path)
WinWaitClose %path% ahk_class AutoHotkey
Run schtasks /run /tn "Servers\Discobot"
Run main.ahk
ExitApp

#include <debug>
#include <functionsahkshouldfuckinghave>
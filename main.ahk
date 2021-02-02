#Include <mustExec>
#NoTrayIcon
if !A_DebuggerName {
	Msgbox This program needs a debugger!
	ExitApp 1
}

debug.init()

; TODO config for each server
includer.init("commands")

try {
	DiscoBot.init()
} catch e {
	Debug.print(e,, {pretty: 2})
	ExitApp 1
}
Return

#Include bot.ahk
#Include <Discord>
#Include <Includer>
#Include <EzGui>
#Include <debug>
#Include <configLoader>
#include *i commands/_includer.ahk
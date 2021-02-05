#Include <mustExec>
#NoTrayIcon
includer.init("commands")

debug.init({console: !A_DebuggerName})

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
#Include <Counter>
#Include <debug>
#Include <urlCode>
#Include <configLoader>
#include *i commands/_includer.ahk
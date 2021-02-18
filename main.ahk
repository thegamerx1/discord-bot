#Include %A_ScriptDir%
#Include <mustExec>
#NoTrayIcon

includer.init("commands")
debug.init({console: !A_DebuggerName, stamp: true})

DiscoBot.init()
Return

#Include bot.ahk
#Include <Discord>
#Include <Includer>
#Include <SHA1>
#Include <ping>
#Include <Counter>
#Include <Unicode>
#Include <debug>
#Include <configLoader>
#include *i commands/_includer.ahk
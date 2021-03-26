#Include %A_ScriptDir%
#Include <mustExec>
#NoTrayIcon

includer.init("commands")
debug.init({console: !A_DebuggerName, stamp: true})

DiscoBot.init()
dashboardServer.init(21901)
Return
#Include bot.ahk
#Include base.ahk
#Include server.ahk

#Include <Discord>
#Include <Includer>
#Include <SHA1>
#Include <Counter>
#Include <Unicode>
#Include <debug>
#Include <configLoader>
#include *i commands/_includer.ahk
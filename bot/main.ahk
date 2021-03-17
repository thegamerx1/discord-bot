#Include %A_ScriptDir%
#Include <mustExec>
#NoTrayIcon

includer.init("commands")
debug.init({console: !A_DebuggerName, stamp: true})

dashboardServer.init(21901)
DiscoBot.init()
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
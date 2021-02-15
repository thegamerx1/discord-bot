#Include %A_ScriptDir%
#Include <mustExec>
#NoTrayIcon
SingleInstance()
includer.init("commands")
debug.init({console: !A_DebuggerName, stamp: true})

DiscoBot.init()
Return

#Include bot.ahk
#Include <Discord>
#Include <Includer>
#Include <Counter>
#Include <debug>
#Include <configLoader>
#include *i commands/_includer.ahk
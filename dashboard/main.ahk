#include <mustExec>
#NoTrayIcon
debug.init({console: !A_DebuggerName})

dashboardClient.init(21901)
dashboard.init()
return
#include connect.ahk
#include webserver.ahk

#include <debug>
#include <httpserver>
#include <configLoader>
#include <discord>
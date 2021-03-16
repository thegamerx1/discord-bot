#include <mustExec>
#NoTrayIcon
debug.init({console: !A_DebuggerName})

class dashboard {
	init() {
		paths := [{method: "GET", path: "/mouse", func: "mouse"}
				 ,{method: "GET", path: "/discordredirect", func: "redirect"}]
		this.http := new httpserver(this, paths, "public", true)
		this.http.serve()
		data := new configLoader("data/settings.json",, true)
		this.oauth := new DiscordOauth(data.client_id, data.client_secret, data.redirect_uri, data.scopes)
	}

	mouse(response, request) {
		MouseGetPos x, y
		response.setRes(x "," y)
	}

	redirect(response, request) {
		if !request.query.code
			response.setRes("Invalid code", 400)
		try {
			token := this.oauth.getCode(request.query.code)
		} catch e {
			response.redirect("/")
			return
		}

		user := this.oauth.apiRequest("users/@me" ,token).json()
		response.setRes(JSON.dump(user))
	}
}
dashboard.init()
return

#include <debug>
#include <httpserver>
#include <configLoader>
#include <discord>
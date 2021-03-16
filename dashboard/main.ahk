#include <mustExec>
#NoTrayIcon
debug.init({console: !A_DebuggerName})

class dashboard {
	init() {
		paths := [{path: "/login", func: "discordlogin"}
				 ,{path: "/dashboard", func: "dashboard"}
				 ,{path: "/getguild", func: "guildData"}]
		this.http := new httpserver(this, paths, "public", true, !!A_DebuggerName)
		this.http.serve()
		data := new configLoader("data/settings.json",, true)
		this.release := data.release
		this.oauth := new DiscordOauth(data.client_id, data.client_secret, data.redirect_uri, data.scopes)
	}

	discordlogin(response, request) {
		if this.release
			return response.redirect("/")
		if request.session["user"] && !request.query.code
			return response.redirect("/dashboard")
		if !request.query.code
			return response.redirect(this.oauth.link)

		try {
			token := this.oauth.getCode(request.query.code)
		} catch e {
			response.redirect("/")
			return
		}

		user := token.request("users/@me")
		request.session["user"] := user
		request.session["token"] := token
		response.redirect("/dashboard")
	}

	guildData(response, request) {
		if this.release
			return response.redirect("/")
		if !request.query.id
			return response.error(400)


	}
	dashboard(response, request) {
		if this.release
			return response.redirect("/")
		html := FileRead("dashboard.html")
		if !request.session["token"].valid()
			return response.redirect("/login")

		guilds := request.session["token"].request("users/@me/guilds")
		out := []
		for _, guild in guilds {
			if (guild.owner || Discord.checkFlag(guild.permissions, "administrator"))
				out.push({name: guild.name, id: guild.id, icon: guild.icon})
		}
		request.session["guilds"] := out
		response.setRes(format(html, JSON.dump({user: request.session["user"], guilds: out})))
	}
}
dashboard.init()
return

#include <debug>
#include <httpserver>
#include <configLoader>
#include <discord>
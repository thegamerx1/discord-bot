#include <mustExec>
#NoTrayIcon
debug.init({console: !A_DebuggerName})

class dashboard {
	init() {
		paths := [{path: "/login", func: "discordlogin"}
				 ,{path: "/guild/{id}", func: "guild"}
				 ,{path: "/dashboard", func: "dashboard"}
				 ,{path: "/", func: "index"}
				 ,{path: "/admin", func: "admin"}]
		this.http := new httpserver(this, paths, "public", true, !!A_DebuggerName)
		data := new configLoader("data/settings.json",, true)
		this.http.setRender("html", "template")
		this.http.serve(80, data.release ? "*" : "localhost")
		this.release := data.release
		this.oauth := new DiscordOauth(data.client_id, data.client_secret, data.redirect_uri, data.scopes)
	}

	index(response, request) {
		response.render("index", {user: request.session["user"]})
	}

	discordlogin(response, request) {
		if (request.session["user"] && !request.get.code)
			return response.redirect("/dashboard")
		if !request.get.code
			return response.redirect(this.oauth.link)

		try {
			token := this.oauth.getCode(request.get.code)
		} catch e {
			debug.print(e)
			response.redirect("/")
			return
		}

		user := token.request("users/@me")
		request.session["user"] := user
		request.session["token"] := token
		response.redirect("/dashboard")
	}

	guild(response, request) {
		if !request.params.id
			return response.error(400)
		response.send(request.params.id)

	}
	dashboard(response, request) {
		if !request.session["token"].valid()
			return response.redirect("/login")

		guilds := request.session["token"].request("users/@me/guilds")
		out := []
		for _, guild in guilds {
			if (guild.owner || Discord.checkFlag(guild.permissions, "administrator"))
				out.push({name: guild.name, id: guild.id, icon: guild.icon})
		}

		response.render("dashboard", {user: request.session["user"], guilds: out})
	}

	admin(response, request) {
		if (request.session["user"].id != 373769618327601152)
			return response.redirect("/")

		response.render("admin")
	}
}
dashboard.init()
return

#include <debug>
#include <httpserver>
#include <configLoader>
#include <discord>
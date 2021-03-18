class dashboard {
	init() {
		paths := [{path: "/login", func: "discordlogin"}
				 ,{path: "/guild/{id}", func: "guild"}
				 ,{path: "/dashboard", func: "dashboard"}
				 ,{path: "/", func: "index"}
				 ,{path: "/guilds", func: "getGuilds"}
				 ,{path: "/logout", func: "logout"}]
		this.http := new httpserver(this, paths, "public", true, !!A_DebuggerName)
		this.config := new configLoader("data/settings.json",, true)
		this.http.setRender("html", "template")
		this.http.serve(80, this.config.release ? "*" : "localhost")
		this.oauth := new DiscordOauth(data.client_id, data.client_secret, data.redirect_uri, data.scopes)
	}

	index(response, request) {
		response.render("index", {user: request.session["user"]})
	}

	logout(response, request) {
		request.session.delete("user")
		return response.redirect("/")
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

	getGuilds(response, request) {
		if !request.session["user"]
			return response.redirect("/")


		guilds := request.session["token"].request("users/@me/guilds")
		out := []
		for _, guild in guilds {
			if (guild.owner || Discord.checkFlag(guild.permissions, "administrator")) {
				try {
					if dashboardClient.query("isIn", {guild.id: guild.id, user: request.session["user"].id})
						out.push({name: guild.name, id: guild.id, icon: guild.icon})
				} catch e {
					return response.error(503)
				}
			}
		}
		response.send(JSON.dump(out))
	}

	guild(response, request) {
		if !request.params.id
			return response.error(400)
		debug.print(request.params.id)
		try {
			data := dashboardClient.query("guild", {id: request.params.id})
		} catch e {
			return response.error(503)
		}
		response.send(data)
	}

	dashboard(response, request) {
		if !request.session["token"].valid()
			return response.redirect("/login")

		response.render("dashboard", {user: request.session["user"]})
	}

	admin(response, request) {
		if (request.session["user"].id != this.config.owner)
			return response.redirect("/")

		response.render("admin")
	}
}
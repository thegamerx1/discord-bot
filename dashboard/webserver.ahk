class dashboard {
	init() {
		paths := [{path: "/login", func: "discordlogin"}
				 ,{path: "/dashboard/{id}", func: "dashboardid"}
				 ,{path: "/dashboard", func: "dashboard"}
				 ,{method: "POST", path: "/save/{id}", func: "postSave"}
				 ,{path: "/", func: "index"}
				 ,{path: "/guilds", func: "guilds"}
				 ,{path: "/logout", func: "logout"}
				 ,{path: "/admin", func: "admin"}]
		this.config := data := new configLoader("data/settings.json",, true)
		this.http := new httpserver(this, paths, "public", true, !this.config.release)
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

	guilds(response, req) {
		if !req.session["user"]
			return response.redirect("/")


		tokencont := new counter()
		guilds := req.session["token"].request("users/@me/guilds")
		request := []
		equivalents := []
		out := []
		guildscont := new counter()
		for _, guild in guilds {
			if (guild.owner || Discord.checkFlag(guild.permissions, "administrator")) {
				request.push(guild.id)
				equivalents.push({name: guild.name, id: guild.id, icon: guild.icon})
			}
		}

		try {
			cont := new counter()
			isIns := dashboardClient.query("isIn", {guilds: request})
		} catch e {
			return response.error(503)
		}

		valid := []
		for i, value in isIns {
			out.push(equivalents[value])
			valid.push(equivalents[value].id)
		}
		debug.print("calc guilds: " guildscont.get() "ms get guilds: " tokencont.get() "ms")
		req.session["guilds"] := valid
		response.send(JSON.dump(out))
	}

	dashboardid(response, request) {
		if !contains(request.params.id, request.session["guilds"])
			return response.redirect("/dashboard")
		if !request.session["user"]
			return response.redirect("/login")

		try {
			data := dashboardClient.query("guild", {id: request.params.id})
		} catch e {
			return response.error(503)
		}
		response.render("dashboard", {user: request.session["user"], guild: data})
	}

	postSave(response, request) {
		if !contains(request.params.id, request.session["guilds"])
			return response.error(401)
		if !(request.form.joinschannel || request.form.editschannel)
			return response.error(400)
		request.form.id := request.params.id
		dashboardClient.query("save", request.form)
		response.send("")
	}

	dashboard(response, request) {
		if !request.session["token"].valid()
			return response.redirect("/login")

		response.render("guilds", {user: request.session["user"]})
	}

	admin(response, request) {
		if (request.session["user"].id != this.config.owner)
			return response.redirect("/")

		response.render("admin")
	}
}
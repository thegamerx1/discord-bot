class command_xkcd extends command_ {
	static cooldown := 3
	, info := "Gets xkcd post"
	, args := [{name: "id"}]
	, commands := [{name: "latest"}, {name: "explain", args: [{name: "id"}]}]
	, category := "Search"

	start() {
		this.cache := {}
	}

	C_explain(ctx, args) {
		static API := "https://explainxkcd.com/"
		ctx.typing()
		http := new requests("get", API args[1],, true)
		http.onFinished := ObjBindMethod(this, "explainResponse", ctx)
		http.send()
	}

	explainResponse(ctx, http) {
		if http.status != 200
			Throw Exception("Error in request",, 400)

		html := new HtmlFile(http.text)
		titles := html.qsa("h2")
		embed := new discord.embed(html.qs("b").textContent, titles[0].nextElementSibling.textContent)
		embed.setFooter("Explain XKCD", "https://i.imgur.com/onzWnfd.png")
		embed.setUrl(http.url)
		ctx.reply(embed)
	}

	C_latest(ctx, args) {
		static API := "https://xkcd.com/info.0.json"
		http := new requests("get", API,, true)
		http.onFinished := ObjBindMethod(this, "response", ctx)
		http.send()
	}

	call(ctx, args) {
		static API := "https://xkcd.com/{}/info.0.json"

		num := args[1]
		if this.cache[num]
			return this.reply(ctx, num)

		ctx.typing()
		http := new requests("get", format(API, num),, true)
		http.onFinished := ObjBindMethod(this, "response", ctx)
		http.send()
	}

	response(ctx, http) {
		if http.status != 200
			Throw Exception("Error in request", -1, 400)
		out := http.json()
		this.cache[out.num] := out
		this.reply(ctx, out.num)
	}

	reply(ctx, num) {
		obj := this.cache[num]
		url := "https://xkcd.com/" obj.num
		embed := new discord.embed(obj.title, obj.alt)
		embed.setImage(obj.img)
		embed.setFooter(url, "https://i.imgur.com/onzWnfd.png")
		embed.setUrl(url)
		embed.setTimestamp(obj.year "-" obj.month "-" obj.day)
		ctx.reply(embed)
	}
}
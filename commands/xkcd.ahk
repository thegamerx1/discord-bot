class command_xkcd extends command_ {
	static cooldown := 3
	, info := "Gets xkcd post"
	, args := [{optional: true, name: "number"}]

	start() {
		this.cache := {}
	}

	call(ctx, args) {
		static random_api := "https://c.xkcd.com/random/comic"
		static number_api := "https://xkcd.com/{}/info.0.json"
		static latest_api := "https://xkcd.com/info.0.json"

		num := args[1]
		if this.cache[num]
			return this.reply(ctx, num)

		ctx.typing()
		latest := (num = "latest")
		if (!args[1] || latest) {
			http := new requests("get", latest ? latest_api : random_api)
			http.allowredirect := false
			out := http.send()
			num := regex(out.headers["Location"], "xkcd\.com\/(?<id>\d+)", "i").id
			if !num
				return ctx.reply("Error in query")
		}
		url := format(number_api, num)
		http := new requests("get", url,, true)
		http.onFinished := ObjBindMethod(this, "response", ctx)
		http.send()
	}

	response(ctx, http) {
		if http.status != 200
			return ctx.reply("Error in request")
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
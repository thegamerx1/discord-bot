class command_xkcd extends command_ {
	static cooldown := 0.5
	, info := "Gets xkcd post"

	call(ctx, args) {
		static random_api := "https://c.xkcd.com/random/comic"
		static number_api := "https://xkcd.com/{}/info.0.json"
		static latest_api := "https://xkcd.com/info.0.json"

		ctx.typing()
		if !args[1] {
			http := new requests("get", random_api)
			out := http.send()
			args[1] := regex(out.headers["Location"], "xkcd\.com\/(?<id>\d+)", "i").id
			if !args[1]
				return ctx.reply("Error in query")
		}

		url := (args[1] = "latest") ? latest_api : format(number_api, args[1])
		http := new requests("get", url)
		try {
			out := http.send().json()
		} catch e {
			return ctx.reply("Error in request")
		}
		url := "https://xkcd.com/" out.num
		embed := new discord.embed(out.title, out.alt)
		embed.setImage(out.img)
		embed.setFooter(url, "https://i.imgur.com/onzWnfd.png")
		embed.setUrl(url)
		embed.setTimestamp(out.year "-" out.month "-" out.day)
		ctx.reply(embed)
	}
}
class command_wolfram extends DiscoBot.command {
	static cooldown := 4
	, info := "Queries wolfram"
	, aliases := ["w", "wa"]
	, args := [{name: "query"}]
	, category := "Search"

	start() {
		this.cache := {}
	}

	call(ctx, args) {
		static API := "https://api.wolframalpha.com/v2/query"
		if this.cache[args[1]]
			return this.reply(ctx, args[1])

		ctx.typing()
		http := new requests("get", API, {appid: this.SET.keys.wolfram
										,input: args[1]
										,output: "json"
										,units: "metric"
										,format: "plaintext"}, true)

		http.headers["Content-Type"] := "application/json"
		http.onFinished := ObjBindMethod(this, "response", ctx, args[1])
		http.send()
	}

	reply(ctx, query) {
		data := this.cache[query]
		embed := new discord.embed(,, 0xFF6600)
		embed.setAuthor("Wolfram|Alpha", "https://i.imgur.com/KFppH69.png")
		if !data.success {
			embed.embed.description := "Wolfram wasn't able to parse your request"

			mean := ""
			for _, value in data.means {
				mean .= value.val "`n"
			}
            embed.addField("Did you mean?", mean)
            embed.addField("Wolfram's tips", data.tips)
			ctx.reply(embed)
			return
		}
		for _, value in data.fields {
			embed.addField(value.name, value.text)
		}
		ctx.reply(embed)
	}

	response(ctx, query, http) {
		if http.status != 200
			this.except(ctx, "Error in query")

		ojson := http.json().queryresult
		obj := {fields: []}
		obj.success := ojson.success
		obj.means := ojson.didyoumeans
		obj.tips := ojson.tips

        has_image := False
        for _, pod in ojson.pods {
            name := pod.title
            id := pod.id
            subpods := pod.subpods

            if (!has_image && InStr(id, "image")) {
                has_image := True
                imagesource := subpods[0].imagesource
                ; if InStr(imagesource, "en.wikipedia.org/wiki/File:" {
                ;     commons_image = await self.unpack_commons_image(ctx.http, imagesource)
                ;     if commons_image
                    obj.image := imagesource
			}

            if obj.fields.length() > 3
                continue

            if (id = "input") {
                value := subpods[1].plaintext
			} else {
				value := ""
                for _, subpod in subpods {
                    plaintext := subpod.plaintext
                    if plaintext
                       value .= plaintext "`n"
				}
			}

			if value {
				wraps := (id = "input") ? "``" : "``````"
				obj.fields.push({name: name, text: wraps value wraps})
			}
		}
		this.cache[query] := obj
        this.reply(ctx, query)
	}
}
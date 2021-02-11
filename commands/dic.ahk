class command_dic extends command_ {
	static cooldown := 2
	, info := "Gets definition of a word"
	, args := [{optional: false, name: "word"}]
	, permissions := ["EMBED_LINKS"]

	start() {
		this.cache := {}
	}

	call(ctx, args) {
		static API := "https://api.dictionaryapi.dev/api/v2/entries/en_US/{}"

		if this.cache[args[1]]
			return this.reply(ctx, args[1])

		ctx.typing()
		http := new requests("GET", format(API, args[1]),, true)
		http.OnFinished := ObjBindMethod(this, "response", ctx, args[1])
		http.send()
	}

	response(ctx, query, http) {
		if (http.status != 200 && http.status != 404)
			return ctx.reply("Error " http.status)

		this.cache[query] := http.json()
		this.reply(ctx, query)
	}

	reply(ctx, query) {
		data := this.cache[query]

		embed := new discord.embed(,, 0x8CD9D7)
		if !data[1].meanings {
			embed.addField("Error", data.title)
			ctx.reply(embed)
			return
		}

		data := data[1]

		for _, value in data.meanings {
			out := ""
			for _, def in value.definitions {
				out .= Chr(8226) " " def.definition "`n"
			}
		}
		embed.addField("Meanings", out)

		for _, value in data.phonetics {
			out := ""
			out .= Chr(8226) " " value.text "`n"
		}
		embed.addField("Phonetics", out)
		ctx.reply(embed)
	}
}
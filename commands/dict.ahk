class command_dict extends DiscoBot.command {
	cooldown := 3
	info := "Gets definition of a word"
	args := [{optional: false, name: "word", type: "str"}]
	category := "Search"

	start() {
		this.cache := {}
	}

	call(ctx, args) {
		static API := "https://api.dictionaryapi.dev/api/v2/entries/en_US/{}"

		if this.cache[args[1]]
			return this.reply(ctx, args[1])

		http := new requests("GET", format(API, args[1]),, true)
		http.OnFinished := ObjBindMethod(this, "response", ctx, args[1])
		http.send()
	}

	response(ctx, query, http) {
		if (http.status != 200 && http.status != 404)
			return ctx.reply("Error " http.status)

		data := http.json()
		obj := {}
		if !data[1].meanings {
			obj.error := data.title
			this.cache[query] := obj
			return this.reply(ctx, query)
		}
		data := data[1]

		means := phonetics := examples := ""
		for _, value in data.meanings {
			for _, def in value.definitions {
				means .= Chr(8226) " " def.definition "`n"
				if def.example
					examples .= Chr(8226) " " def.example "`n"`
			}
		}

		for _, value in data.phonetics {
			phonetics .= Chr(8226) " " value.text "`n"
		}
		obj.means := means
		obj.examples := examples
		obj.phonetics := phonetics


		this.cache[query] := obj
		this.reply(ctx, query)
	}

	reply(ctx, query) {
		data := this.cache[query]

		embed := new discord.embed(,, 0x8CD9D7)
		if data.error {
			embed.addField("Error", data.error)
			ctx.reply(embed)
			return
		}

		embed.addField("Meanings", data.means)
		embed.addField("Examples", data.examples)
		embed.addField("Phonetics", data.phonetics)
		ctx.reply(embed)
	}
}
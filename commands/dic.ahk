class command_dic extends command_ {
	static owneronly := false
	, cooldown := 2
	, info := "Gets definition of a word"
	, args := [{optional: false, name: "word"}]

	start() {
		this.cache := {}
	}

	call(ctx, args) {
		static API := "https://www.twinword.com/api/word/definition/latest/"

		if this.cache[args[1]]
			return this.reply(ctx, args[1])

		ctx.typing()
		http := new requests("POST", API,, true)
		http.OnFinished := ObjBindMethod(this, "response", ctx, args[1])
		http.headers["Referrer"] := "https://www.twinword.com/api/word-dictionary.php"
		http.headers["origin"] := "https://www.twinword.com"
		http.headers["Content-Type"] := "application/x-www-form-urlencoded"
		http.send(http.encode({entry: args[1]}))
	}

	response(ctx, query, http) {
		if http.status != 200
			return ctx.reply("Error " http.status)

		this.cache[query] := http.json()
		this.reply(ctx, query)
	}

	reply(ctx, query) {
		data := this.cache[query]

		embed := new discord.embed(,, 0x8CD9D7)
		if (data.result_code != 200) {
			embed.addField("Error " data.result_code, data.result_msg)
			ctx.reply(embed)
			return
		}

		embed.addField("IPA", data.ipa)
		for key, value in data.meaning {
			value := StrSplit(value, "`n", "`r")
			out := ""
			for _, line in value {
				out .= Chr(8226) " " SubStr(line, 6) "`n"
			}
			embed.addField(format("{:T}", key), out)
		}
		ctx.reply(embed)
	}
}
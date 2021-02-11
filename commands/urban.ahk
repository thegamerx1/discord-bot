class command_urban extends command_ {
	static cooldown := 2
	, info := "Gets word definition from urban dictionary"
	, args := [{optional: false, name: "word"}]
	, permissions := ["EMBED_LINKS", "ADD_REACTIONS"]

	static API := "https://www.urbandictionary.com/define.php?term="

	start() {
		this.cache := {}
	}

	call(ctx, args) {
		if this.cache[args[1]] {
			return this.reply(ctx, args[1])
		}
		ctx.typing()
		http := new requests("GET", this.API args[1],, true)
		http.onFinished := ObjBindMethod(this, "response", ctx, args[1])
		http.send()
	}
	response(ctx, query, http) {
		if http.status != 200
			return ctx.react("bot_no")

		html := new HtmlFile(http.text)
		most := {}
		for _, value in html.Each(html.qsa("#content .def-panel")) {
			if InStr(value.querySelector(".ribbon").textContent, "day")
				continue
			obj := {}
			obj.likes := value.querySelector("div.def-footer a.up > span").textContent
			if obj.likes < most.likes
				continue
			obj.dislikes := value.querySelector("div.def-footer a.down > span").textContent
			obj.ratio := obj.likes/obj.dislikes
			obj.word := value.querySelector("div.def-header > a").innerHTML
			obj.meaning := value.querySelector("div.meaning").textContent
			obj.example := value.querySelector("div.example").textContent
			obj.contributor := value.querySelector(".contributor > a").textContent
			most := obj
		}
		if (!most.word)
			return ctx.reply("Error in query")
		this.cache[query] := most
		this.reply(ctx, query)
	}
	reply(ctx, query) {
		most := this.cache[query]
		if !most
			Throw Exception("Most is null?" -1)

		embed := new discord.embed("Definition of " most.word, most.meaning)
		embed.addField("Example", most.example)
		embed.setUrl(this.API StrReplace(query, " ", "%20"))
		embed.setFooter("Requested by " ctx.author.name, ctx.author.avatar)
		embed.addField(":thumbsup:", most.likes, true)
		embed.addField(":thumbsdown:", most.dislikes, true)
		embed.addField("Sent by", most.contributor)
		ctx.reply(embed)
	}
}
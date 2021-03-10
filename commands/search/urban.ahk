#Include <HtmlFile>
class command_urban extends DiscoBase.command {
	cooldown := 3
	info := "Gets word definition from urban dictionary"
	args := [{optional: false, name: "word"}]

	static API := "https://www.urbandictionary.com/define.php?term="

	start() {
		this.cache := {}
	}

	call(ctx, args) {
		if this.cache[args[1]]
			return this.reply(ctx, args[1])

		ctx.typing()
		http := new requests("GET", this.API args[1],, true)
		http.onFinished := ObjBindMethod(this, "response", ctx, args[1])
		http.send()
	}
	response(ctx, query, http) {
		if http.status != 200
			this.except(ctx, "Not found")

		html := new HtmlFile(http.text)
		most := {}
		index := 0
		for _, value in html.Each(html.qsa("#content .def-panel")) {
			if InStr(value.querySelector(".ribbon").textContent, "day")
				continue
			if (index++ > 4)
				break
			obj := {}
			obj.likes := value.querySelector("div.def-footer a.up > span").textContent
			obj.dislikes := value.querySelector("div.def-footer a.down > span").textContent
			obj.ratio := obj.likes/obj.dislikes
			if obj.ratio < most.ratio
				continue
			obj.ratio := obj.likes/obj.dislikes
			obj.word := value.querySelector("div.def-header > a").textContent
			obj.meaning := value.querySelector("div.meaning").textContent
			obj.example := value.querySelector("div.example").textContent
			obj.contributor := value.querySelector(".contributor > a").textContent
			most := obj
		}
		if !StrLen(most.word)
			this.except(ctx, "Error in query")

		this.cache[query] := most
		this.reply(ctx, query)
	}
	reply(ctx, query) {
		most := this.cache[query]

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
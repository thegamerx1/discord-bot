class command_gateway extends command_ {
	static owneronly := true
	, info := "Gets gateway shit"
	, permissions := ["EMBED_LINKS"]

	start() {
		this.events := {}
	}

	call(ctx, args) {
		rows := new textrower(0, [{align: "left", name: "EVENT"}, {align: "right", name: "COUNT"}])
		embed := new discord.embed()
		for key, value in this.events {
			rows.addRow("EVENT", key)
			rows.addRow("COUNT", value)
		}
		embed.setContent("``" rows.get() "``")
		ctx.reply(embed)
	}

	_event(event, data) {
		if !this.events[event]
			this.events[event] := 0
		this.events[event]++
	}
}
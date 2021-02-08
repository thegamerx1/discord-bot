class command_gateway extends command_ {
	static owneronly := true
	, info := "Gets gateway shit"

	start() {
		this.events := {}
	}

	call(ctx, args) {
		embed := new discord.embed()
		for key, value in this.events {
			embed.addField(key, value)
		}
		ctx.reply(embed)
	}

	_event(event, data) {
		if !this.events[event]
			this.events[event] := 0
		this.events[event]++
	}
}
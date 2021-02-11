class command_uptime extends command_ {
	static cooldown := 5
	, info := "Gets bot uptime"
	, permissions := ["EMBED_LINKS"]

	start() {
		this.uptime := new Counter(2, true)
	}

	call(ctx, args) {
		time := this.uptime.get()
		if (time < 5*1000)
			return ctx.reply("I just started let me fucking chill")
		embed := new discord.embed("Uptime", "I have been up for: **" niceDate(time) "**", 0x3DBF0D)
		ctx.reply(embed)
	}
}
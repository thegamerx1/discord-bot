class command_ping extends command_ {
	static cooldown := 5
	, info := "Checks the ping of the bot"

	call(ctx, args) {
		time := new Counter()
		msg := ctx.reply("Ping")
		embed := new discord.embed(, "Pong on " time.get() "ms")
		embed.setContent("Pong.")
		msg.edit(embed)
	}
}
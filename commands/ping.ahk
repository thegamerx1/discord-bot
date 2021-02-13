class command_ping extends command_ {
	static cooldown := 1
	, info := "Checks the ping of the bot"
	, category := "Fun"

	call(ctx, args) {
		time := new Counter()
		msg := ctx.reply("Ping")
		embed := new discord.embed(, "Pong on " time.get() "ms")
		embed.setContent("Pong.")
		msg.edit(embed)
	}
}
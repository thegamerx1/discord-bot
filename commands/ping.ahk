class command_ping extends DiscoBot.command {
	cooldown := 2
	info := "Checks the ping of the bot"
	category := "Bot"

	call(ctx, args) {
		time := new Counter(,false)
		msg := ctx.reply("Ping")
		embed := new discord.embed(, "Ping " time.get() "ms")
		embed.setContent("Pong.")
		msg.edit(embed)
	}
}
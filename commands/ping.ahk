class command_ping extends DiscoBot.command {
	cooldown := 2
	info := "Checks the ping of the bot"
	category := "Bot"

	call(ctx, args) {
		time := new Counter(,false)
		msg := ctx.reply("Ping")
		embed := new discord.embed("Pong", "Ping " Round((msg.timestamp-ctx.timestamp)*1000, 2) "ms")
		msg.edit(embed)
	}
}
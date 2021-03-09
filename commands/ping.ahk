class command_ping extends DiscoBot.command {
	cooldown := 2
	info := "Checks the ping of the bot"
	category := "Bot"
	aliases := ["pong"]

	call(ctx, args) {
		reply := InStr(ctx.message, "pong") ? "Ping" : "Pong"
		msg := ctx.reply(reply)
		embed := new discord.embed(reply, "Ping " Round((msg.timestamp-ctx.timestamp)*1000, 2) "ms")
		msg.edit(embed)
	}
}
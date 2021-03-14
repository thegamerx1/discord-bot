class command_ping extends DiscoBase.command {
	cooldown := 2
	info := "Checks the ping of the bot"
	aliases := ["pong"]

	call(ctx, args) {
		reply := InStr(ctx.content, "pong") ? "Ping" : "Pong"
		msg := ctx.reply(reply)
		embed := new discord.embed()
		embed.setContent(reply)
		embed.addField("Ping", Round((msg.timestamp-ctx.timestamp)*1000, 2) "ms", true)
		embed.addField("Heartbeat", ctx.api.ws.ping ? ctx.api.ws.ping "ms" : "Not ready yet", true)
		msg.edit(embed)
	}
}
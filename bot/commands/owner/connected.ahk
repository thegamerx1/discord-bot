class command_connected extends DiscoBase.command {
	cooldown := 2
	owneronly := true

	E_MESSAGE_CREATE(ctx) {
		if (ctx.author.id == 805290913958068245) {
			if (ctx.channel.canI(["SEND_MESSAGES"]))
				ctx.reply("Connected!")
		}
	}
}
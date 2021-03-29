class command_connected extends DiscoBase.command {
	cooldown := 2
	owneronly := true

	start() {
		this.replies := {}
	}

	E_MESSAGE_CREATE(ctx) {
		if (ctx.author.id == 805290913958068245 && ctx.content == "Connected!") {
			if (ctx.channel.canI(["SEND_MESSAGES"])) {
				reply := ctx.reply("Connected!")
				this.replies[ctx.id] := reply.id
			}
		}
	}

	E_MESSAGE_DELETE(ctx) {
		if !ctx.channel.canI(["SEND_MESSAGES"])
			return
		for key, value in this.replies {
			if (ctx.id == key) {
				msg := ctx.channel.getMessage(value)
				try {
					msg.delete()
				} catch e {
					ctx.channel.send(e)
				}
			}
		}
	}
}
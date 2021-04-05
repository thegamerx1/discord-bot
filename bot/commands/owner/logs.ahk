class command_logs extends DiscoBase.command {
	owneronly := true
	info := "Gets bot logs"
	args := [{optional: true, name: "lines", default: 20}]

	call(ctx, args) {
		logs := strGetLast(debug.log, args[1])
		if !logs
			this.except(ctx, "Logs brokey")
		file := new discord.messageFile("prolog", StripNewline(logs))
		msg := ctx.reply(file)
		msg.react("trash")
	}

	E_MESSAGE_REACTION_ADD(ctx) {
		if (ctx.emoji == "trash") {
			if (ctx.message.author.id = ctx.api.self.id)
				if (ctx.author.id = ctx.api.owner.id)
					ctx.message.delete()
		}
	}
}
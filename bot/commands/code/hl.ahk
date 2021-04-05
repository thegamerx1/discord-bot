class command_hl extends DiscoBase.command {
	cooldown := 3
	info := "Highlights your text"
	args := [{optional: false, name: "code"}]
	permissions := ["MANAGE_MESSAGES"]

	call(ctx, args) {
		code := discord.utils.getCodeBlock(args[1])

		ctx.delete()
		lang := code.lang ? code.lang : "autohotkey"
		file := new discord.messageFile(lang, StripNewline(code.code), "Paste by " ctx.author.mention)
		msg := ctx.reply(file)
		msg.react("trash")
	}

	E_MESSAGE_REACTION_ADD(ctx) {
		if (ctx.emoji == "trash") {
			if (ctx.message.author.id = ctx.api.self.id)
				if (ctx.author.id = discord.utils.getId(ctx.message.content))
					ctx.message.delete()
		}
	}
}
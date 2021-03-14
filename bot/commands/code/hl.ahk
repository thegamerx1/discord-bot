class command_hl extends DiscoBase.command {
	cooldown := 3
	info := "Highlights your text"
	args := [{optional: false, name: "code"}]

	start() {
		this.emoji := Unicode.get("put_litter_in_its_place")
	}

	call(ctx, args) {
		code := discord.utils.getCodeBlock(args[1])

		ctx.delete()
		embed := new discord.embed(,"_Paste by " ctx.author.mention "_")
		embed.setContent(discord.utils.codeblock(code.lang, code.code))
		msg := ctx.reply(embed)
		msg.react(this.emoji)
	}

	E_MESSAGE_REACTION_ADD(ctx) {
		if ctx.emoji != this.emoji
			return

		if (ctx.message.author.id = ctx.api.self.id)
			if (ctx.author.id = discord.utils.getId(ctx.message.embeds[1].description))
				ctx.message.delete()

	}
}
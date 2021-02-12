class command_hl extends command_ {
	static cooldown := 5
	, info := "Highlights your text"
	, args := [{optional: false, name: "code"}]
	, permissions := ["EMBED_LINKS"]

	call(ctx, args) {
		static regex := "^``+(?<lang>\w+)?\n(?<code>.*?)``+$"
		code := args[1]
		if match := regex(code, regex, "s")
			code := match.code

		ctx.delete()
		embed := new discord.embed(,"_Paste by " ctx.author.mention "_")
		embed.setFooter(ctx.author.id)
		embed.setContent("``````" match.lang "`n" discord.utils.sanitize(code) "``````")
		msg := ctx.reply(embed)
		msg.react("🚮")
	}

	E_MESSAGE_REACTION_ADD(ctx) {
		msg := ctx.api.GetMessage(ctx.channel, ctx.message)
		if ctx.emoji != "🚮"
			return

		if (msg.author.id == ctx.api.self.id) {
			if (ctx.author.id = msg.data.embeds[1].footer.text) {
				msg.delete()
			}
		}
	}
}
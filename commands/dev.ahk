class command_dev extends DiscoBot.command {
	static owneronly := true
	, info := "Enabled devmode"
	, category := "Owner"
	, args := [{name: "enable", type: "bool"}]

	call(ctx, args) {
		this.bot.settings.data.dev := args[1]
		ctx.reply(new discord.embed(, ctx.getEmoji("bot_ok") " Dev mode " (args[1] ? "enabled" : "disabled"), (args[1] ? 0x2A7A29 : 0xB03D3B)))
	}

	E_MESSAGE_CREATE(ctx) {
		if !(this.bot.settings.data.dev || this.bot.bot.release)
			return

		if (ctx.author.id != this.bot.bot.owner_id)
			return 1 ;CAPTURE NON OWNER MESSAGES

	}
}
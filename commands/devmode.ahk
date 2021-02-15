class command_devmode extends DiscoBot.command {
	static owneronly := true
	, info := "Enabled devmode"
	, category := "Owner"
	, args := [{name: "enable", type: "bool"}]

	call(ctx, args) {
		status := args[1] ? "enabled" : "disabled"
		if (args[1] = this.bot.settings.data.dev)
			this.except(ctx, "Dev mode already " status "!")
		this.bot.settings.data.dev := args[1]
		ctx.reply(new discord.embed(, ctx.getEmoji("bot_ok") " Dev mode " status, (args[1] ? 0x2A7A29 : 0xB03D3B)))
	}

	E_MESSAGE_CREATE(ctx) {
		if this.SET.release
			return

		if (this.bot.settings.data.dev && !ctx.author.isBotOwner)
			return 1 ;CAPTURE NON OWNER MESSAGES

	}
}
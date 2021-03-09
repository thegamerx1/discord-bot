class command_devmode extends DiscoBot.command {
	owneronly := true
	info := "Enabled devmode"
	category := "Owner"
	args := [{name: "enable", type: "bool"}]
	commands := [{name: "status"}]

	c_status(ctx) {
		enabled := this.bot.settings.data.dev
		status := enabled ? "enabled" : "disabled"
		ctx.reply(new discord.embed(, ctx.getEmoji(enabled ? this.bot.randomCheck() : "no") " Dev mode is " status, enabled ? 0x2A7A29 : 0xB03D3B))
	}

	call(ctx, args) {
		if this.SET.release
			this.except(ctx, "Dev mode is always disabled on release!")

		args[1] := Bool(args[1])
		status := args[1] ? "enabled" : "disabled"
		if (args[1] = this.bot.settings.data.dev)
			this.except(ctx, "Dev mode already " status "!")
		this.bot.settings.data.dev := args[1]
		ctx.reply(new discord.embed(, ctx.getEmoji(this.bot.randomCheck()) " Dev mode " status, args[1] ? 0x2A7A29 : 0xB03D3B))
	}

	E_MESSAGE_CREATE(ctx) {
		if this.SET.release
			return

		if (this.bot.settings.data.dev && !ctx.author.isBotOwner)
			return 1 ;CAPTURE NON OWNER MESSAGES
	}
}
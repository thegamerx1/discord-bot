class command_reload extends DiscoBot.command {
	static owneronly := true
	, info := "Restarts the bot"
	, aliases := ["restart"]
	, permissions := ["ADD_REACTIONS"]
	, category := "Owner"


	E_READY(data) {
		if (this.bot.resume) {
			this.bot.api.RemoveReaction(this.bot.resume[1], this.bot.resume[2], "bot_loading")
			this.bot.api.AddReaction(this.bot.resume[1], this.bot.resume[2], "bot_ok")
		}
	}

	call(ctx, args) {
		ctx.react("bot_loading")
		this.bot.api.disconnect()
		Reload(ctx.channel.id "," ctx.data.id)
	}
}
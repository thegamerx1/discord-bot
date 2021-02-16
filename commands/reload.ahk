class command_reload extends DiscoBot.command {
	static owneronly := true
	, info := "Restarts the bot"
	, aliases := ["restart"]
	, permissions := ["ADD_REACTIONS"]
	, category := "Owner"


	E_READY() {
		if (this.bot.resume) {
			this.bot.api.RemoveReaction(this.bot.resume[1], this.bot.resume[2], "bot_loading")
			this.bot.api.AddReaction(this.bot.resume[1], this.bot.resume[2], "bot_ok")
		}
	}

	call(ctx, args) {
		critical
		ctx.react("bot_loading")
		this.bot.api.disconnect()
		if this.SET.release {
			Run schtasks /end /tn "Servers\Discobot"
		}
		Reload("-reload " ctx.channel.id "," ctx.data.id)
	}
}
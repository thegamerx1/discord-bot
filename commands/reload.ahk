class command_reload extends DiscoBot.command {
	owneronly := true
	info := "Restarts the bot"
	aliases := ["restart"]
	permissions := ["ADD_REACTIONS"]
	category := "Owner"


	E_READY() {
		if (this.bot.resume) {
			this.bot.api.RemoveReaction(this.bot.resume[1], this.bot.resume[2], "loading")
			this.bot.api.AddReaction(this.bot.resume[1], this.bot.resume[2], this.bot.randomCheck())
		}
	}

	call(ctx, args) {
		critical
		ctx.react("loading")
		this.bot.api.disconnect()
		if this.SET.release {
			Run schtasks /end /tn "Servers\Discobot"
		}
		Reload("-reload " ctx.channel.id "," ctx.id)
	}
}
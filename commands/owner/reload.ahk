class command_reload extends DiscoBase.command {
	owneronly := true
	info := "Restarts the bot"
	aliases := ["restart"]

	E_READY() {
		if (this.bot.resume) {
			msg := this.bot.api.GetMessage(this.bot.resume[1], this.bot.resume[2])
			msg.unReact("loading")
			msg.react(this.bot.randomCheck())
		}
	}

	call(ctx, args) {
		critical
		ctx.react("loading")
		ctx.api.disconnect()
		Reload("-reload " ctx.channel.id "," ctx.id)
	}
}
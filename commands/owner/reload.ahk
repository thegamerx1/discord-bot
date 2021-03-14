class command_reload extends DiscoBase.command {
	owneronly := true
	info := "Restarts the bot"
	aliases := ["restart"]

	E_READY() {
		if (this.bot.resume) {
			try {
				debug.print(this.bot.resume)
				channel := new discord.channel(this.bot.api, this.bot.resume[1])
				msg := channel.getMessage(this.bot.resume[2])
				msg.unReact("loading")
				msg.react(this.bot.randomCheck())
			} catch e {
				debug.print("Error reloading")
				debug.print(e)
			} finally {
				this.bot.delete("resume")
			}
		}
	}

	call(ctx, args) {
		critical
		ctx.react("loading")
		ctx.api.delete()
		Reload("-reload " ctx.channel.id "," ctx.id)
	}
}
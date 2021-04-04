class command_reload extends DiscoBase.command {
	owneronly := true
	info := "Restarts the bot"
	aliases := ["restart"]

	E_READY() {
		if (this.bot.resume) {
			try {
				channel := new discord.channel(this.bot.api, this.bot.resume[1])
				msg := channel.getMessage(this.bot.resume[2])
				msg.unReact("loading")
				msg.react(this.bot.randomCheck())
				debug.print("Reload react sucessful: " msg.id)
			} catch e {
				debug.print("Reload react failed")
				debug.print(e)
			} finally {
				this.bot.delete("resume")
			}
		} else {
			debug.print("Reload react not activated")
		}
	}

	call(ctx, args) {
		critical
		ctx.react("loading")
		ctx.api.delete()
		Reload("-reload " ctx.channel.id "," ctx.id)
	}
}
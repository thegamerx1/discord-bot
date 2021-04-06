class command_react extends DiscoBase.command {
	cooldown := 3
	info := "Manage bot react"
	userperms := ["ADMINISTRATOR"]

	start() {
		this.wait := {}
		this.disables := {}
	}

	call(ctx, args) {
		ctx.reply("Manage me through the dashboard!")
	}

	E_MESSAGE_CREATE(ctx) {
		static ECOOLDOWN := 5*60*1000
		guild := this.bot.getGuild(ctx.guild.id)
		if !guild.randomReact
			return
		if (random(1,100) == 69 && ctx.channel.canI(["ADD_REACTIONS", "USE_EXTERNAL_EMOJIS"])) {
			if this.isBlocked(ctx.author)
				return
			emote := random(ctx.api.getGuild(this.set.owner.guild).emojis)
			try {
				ctx.react(emote.name)
			} catch {
				this.disables[ctx.author.id] := A_TickCount + ECOOLDOWN
			}
		}
	}

	isBlocked(id) {
		static COOLDOWN := 3000
		if id.bot
			return true

		if (this.wait[id.id] < A_TickCount && this.wait[id.id]) {
			return true
		} else {
			this.wait[id.id] := A_TickCount + COOLDOWN
		}
		if (this.disables[id.id] < A_TickCount && this.disables[id.id]) {
			return true
		}
	}
}
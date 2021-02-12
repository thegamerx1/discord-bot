class command_reload extends command_ {
	static owneronly := true
	, aliases := ["restart"]
	, permissions := ["ADD_REACTIONS"]


	E_READY(data) {
		if (this.bot.resumedata) {
			this.bot.api.RemoveReaction(this.bot.resumedata[1], this.bot.resumedata[2], "bot_loading")
			this.bot.api.AddReaction(this.bot.resumedata[1], this.bot.resumedata[2], "bot_ok")
		}
	}

	call(ctx, args) {
		ctx.react("bot_loading")
		data := ctx.data.channel_id "," ctx.data.id
		debug.print(data)
		this.bot.api.disconnect()
		Run % "AutoHotkeyU64 /restart main.ahk -reload " data
		ExitApp 0
	}
}
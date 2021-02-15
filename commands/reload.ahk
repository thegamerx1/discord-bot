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
		data := ctx.data.channel_id "," ctx.data.id
		debug.print(data)
		this.bot.api.disconnect()
		if this.bot.bot.release
			Run schtasks /run /tn "Servers\DiscoBot"
			Run % "main.ahk -reload " data
		else
			Run % "AutoHotkeyU64 /restart main.ahk -reload " data
		ExitApp 0
	}
}
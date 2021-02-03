class command_reload extends command_ {
	static owneronly := true
	, cooldown := 0
	, info := "Restarts the bot"

	ready() {
		if (this.bot.resumedata)
			this.bot.api.AddReaction(this.bot.resumedata[3], this.bot.resumedata[4], "✅")
	}

	call(ctx, args := "") {
		; bot.api.AddReaction(data.channel.id, data.id, ":ballot_box_with_check:")
		; bot.api.EditMessage()
		ctx.react("🔄")
		data := this.bot.api.session_id "," this.bot.api.seq "," ctx.data.channel_id "," ctx.data.id
		debug.print(data)
		Sleep 500
		Run % "AutoHotkeyU64 /restart main.ahk -reload " data
		ExitApp 0
	}
}
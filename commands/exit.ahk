class command_exit extends command_ {
	static owneronly := true
	, cooldown := 0
	, info := "Exits the bot safely"

	call(ctx, args := "") {
		this.bot.api.disconnect()
		exitapp 0
	}
}
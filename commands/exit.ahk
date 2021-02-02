class command_exit {
	static owneronly := true
	, cooldown := 0
	, info := "Exits the bot safely"

	call(bot, data, args := "") {
		bot.api.disconnect()
		exitapp 0
	}
}
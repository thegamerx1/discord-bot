class command_ping {
	static owneronly := false
	, cooldown := 5
	, info := "Checks the ping of the bot"

	call(bot, data, args := "") {
		bot.api.SendMessage(data.channel_id, "Pong")
		; TODO: reply with delay
	}
}
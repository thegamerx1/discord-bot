class command_invite {
	static owneronly := false
	, cooldown := 5
	, info := "Gets a invite for the bot"

	call(bot, data, args := "") {
		static base := "https://discord.com/api/oauth2/authorize?client_id={}&permissions={}&scope=bot"
		bot.api.SendMessage(data.channel_id, format(base, bot.bot.USER_ID, bot.bot.PERMISSIONS))
	}
}
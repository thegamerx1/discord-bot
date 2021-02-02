class command_prefix {
	static owneronly := true
	, cooldown := 0
	, info := "Gets output of a message"

	call(bot, data, args := "") {
		if (StrLen(param) > 1 || StrLen(param) < 1) {
			bot.api.SendMessage(data.channel_id, "Prefix must be 1 char!")
			return
		}
		bot.guilds[data.guild_id].data.prefix := param
		this.SendMessage(data.channel_id, "Prefix set to " param)
		; TODO: REact with check
	}
}
class command_print {
	static owneronly := true
	, cooldown := 0
	, info := "Gets output of a message"

	call(bot, data, args := "") {
		embed := new discord.embed("test")
		embed.setEmbed("Output", "``````json`n" JSON.dump(data) "``````")
		bot.api.SendMessage(data.channel_id, embed)
	}
}
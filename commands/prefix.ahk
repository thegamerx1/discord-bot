class command_prefix extends DiscoBot.command {
	static cooldown := 3
	, info := "Sets server prefix for the bot"
	, args := [{optional: false, name: "prefix"}]
	, permissions := ["CHANGE_NICKNAME"]
	, userperms := ["ADMINISTRATOR"]
	, category := "Bot"

	call(ctx, args) {
		length := StrLen(args[1])
		if (length > 3 || length < 1)
			return ctx.reply("Prefix must be between 1 and 3 characters!")

		this.bot.guilds[ctx.data.guild_id].data.prefix := args[1]
		ctx.react("bot_ok")
	}
}
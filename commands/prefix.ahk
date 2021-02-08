class command_prefix extends command_ {
	static serverowneronly := true
	, cooldown := 10
	, info := "Sets server prefix for the bot"
	, args := [{optional: false, name: "prefix"}]

	call(ctx, args) {
		if StrLen(args[1]) != 1
			return ctx.reply("Prefix must be 1 char!")

		this.bot.guilds[ctx.data.guild_id].data.prefix := args[1]
		ctx.react("bot_ok")
	}
}
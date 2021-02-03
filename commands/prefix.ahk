class command_prefix extends command_ {
	static serverowneronly := true
	, cooldown := 0
	, info := "Gets output of a message"

	call(ctx, args := "") {
		if (StrLen(args) > 1 || StrLen(args) < 1) {
			ctx.reply("Prefix must be 1 char!")
			return
		}
		this.bot.guilds[data.guild_id].data.prefix := param
		ctx.react("✅")
	}
}
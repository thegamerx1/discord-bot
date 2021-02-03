class command_invite extends command_ {
	static owneronly := false
	, cooldown := 5
	, info := "Gets a invite for the bot"

	call(ctx, args := "") {
		static base := "https://discord.com/api/oauth2/authorize?client_id={}&permissions={}&scope=bot"
		ctx.reply(format(base, this.bot.bot.USER_ID, this.bot.bot.PERMISSIONS))
	}
}
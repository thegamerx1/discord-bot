class command_invite extends command_ {
	static cooldown := 10
	, info := "Gets a invite for the bot"

	call(ctx, args) {
		static base := "https://discord.com/api/oauth2/authorize?client_id={}&permissions={}&scope=bot"
		embed := new discord.embed("Invite link",, 0x65C85B)
		embed.setUrl(format(base, ctx.api.USER_ID, this.bot.bot.PERMISSIONS))
		embed.setFooter("Im currently not public")
		ctx.reply(embed)
	}
}
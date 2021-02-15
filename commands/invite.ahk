class command_invite extends DiscoBot.command {
	static cooldown := 10
	, info := "Gets a invite for the bot to join your server"
	, category := "Bot"
	, aliases := ["add"]

	start() {
		static base := "https://discord.com/api/oauth2/authorize?client_id={}&permissions={}&scope=bot"
		this.link := format(base, this.bot.api.self.id, this.bot.bot.PERMISSIONS)
	}

	call(ctx, args) {
		static base := "https://discord.com/api/oauth2/authorize?client_id={}&permissions={}&scope=bot"
		embed := new discord.embed("Invite link",, 0x65C85B)
		embed.setUrl(this.link)
		ctx.reply(embed)
	}
}
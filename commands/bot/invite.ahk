class command_invite extends DiscoBase.command {
	cooldown := 2
	info := "Gets a invite for the bot to join your server"
	aliases := ["add"]

	E_ready() {
		static base := "https://discord.com/api/oauth2/authorize?client_id={}&permissions={}&scope=bot"
		this.link := format(base, this.bot.api.self.id, this.SET.permissions)
	}

	call(ctx, args) {
		embed := new discord.embed("Invite link",, 0x65C85B)
		embed.setUrl(this.link)
		ctx.reply(embed)
	}
}
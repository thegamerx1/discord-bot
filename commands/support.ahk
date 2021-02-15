class command_support extends DiscoBot.command {
	static cooldown := 10
	, info := "Gets a invite for the suppport server"
	, category := "Bot"

	call(ctx, args) {
		embed := new discord.embed("Support server link",, 0x65C85B)
		embed.setUrl(this.bot.bot.SUPPORT_SERVER)
		ctx.reply(embed)
	}
}
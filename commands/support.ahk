class command_support extends DiscoBot.command {
	cooldown := 2
	info := "Gets a invite for the suppport server"
	category := "Bot"

	call(ctx, args) {
		embed := new discord.embed("Support server link",, 0x65C85B)
		embed.setUrl(this.SET.owner.server_invite)
		ctx.reply(embed)
	}
}
class command_support extends DiscoBase.command {
	cooldown := 2
	info := "Gets a invite for the suppport server"

	call(ctx, args) {
		embed := new discord.embed("Support server link",, 0x65C85B)
		embed.setUrl(this.SET.owner.server_invite)
		ctx.reply(embed)
	}
}
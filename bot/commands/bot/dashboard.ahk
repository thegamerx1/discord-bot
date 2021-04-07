class command_dashboard extends DiscoBase.command {
	cooldown := 2
	info := "Gets a link to the dashboard"
	aliases := ["dash"]

	call(ctx, args) {
		embed := new discord.embed(, "http://discobot.ndrx.ml/")
		ctx.reply(embed)
	}
}
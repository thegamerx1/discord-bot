class command_dashboard extends DiscoBase.command {
	cooldown := 2
	info := "Gets a link to the dashboard"
	aliases := ["dash"]

	call(ctx, args) {
		embed := new discord.embed(, "http://discobot.ml/")
		ctx.reply(embed)
	}
}
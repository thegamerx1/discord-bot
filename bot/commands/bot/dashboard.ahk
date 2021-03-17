class command_dashboard extends DiscoBase.command {
	cooldown := 2
	info := "Gets a link to the dashboard"
	aliases := ["pong"]

	call(ctx, args) {
		embed := new discord.embed(, "http://52.178.158.28/")
		ctx.reply(embed)
	}
}
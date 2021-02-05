class command_server extends command_ {
	static  cooldown := 0
	, info := "Gets info about the server"

	call(ctx, args) {
		ctx.typing()
		embed := new discord.embed(ctx.guild.name, "**ID**: " ctx.guild.id)
		embed.addField("Owner", "<@!" ctx.guild.owner ">", true)
		embed.addField("Region", ctx.guild.data.region, true)
		ctx.reply(embed)
	}
}
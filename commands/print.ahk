class command_print extends command_ {
	static owneronly := true
	, cooldown := 0
	, info := "Gets output of a message"

	call(ctx, args := "") {
		embed := new discord.embed()
		embed.setEmbed("Output", "``````json`n" data := JSON.dump(ctx.data) "``````")
		ctx.reply(embed)
	}
}
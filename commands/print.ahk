class command_print extends command_ {
	static owneronly := true
	, cooldown := 0
	, info := "Gets output of a message"

	call(ctx, args := "") {
		embed := new discord.embed("test")
		embed.setEmbed("Output", "json`n" JSON.dump(data))
		ctx.reply(embed)
	}
}
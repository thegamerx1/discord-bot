class command_test extends command_ {
	static owneronly := true
	, info := "Delet server"

	call(ctx, args) {
		embed := new discord.embed("embed title","embed content", 0x21633F)
		embed.setCOntent("``````json`nworky?``````")
		embed.addField("Run time", data.time, true)
		embed.addField("Characters", data.length, true)
		embed.addField("Lines", data.lines, true)
		embed.setAuthor("Something")
		ctx.reply(embed)
	}
}
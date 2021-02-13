class command_test extends command_ {
	static owneronly := true

	call(ctx, args) {
		embed := new discord.embed("", "", 0x3E4BBB)
		embed.addField("1", "https://github.com/thegamerx1/discord-bot", true)
		embed.addField("2", "https://github.com/thegamerx1/discord-bot", true)
		embed.addField(" ", " ",, true)
		embed.addField("3", "https://github.com/thegamerx1/ahk-libs", true)
		embed.addField("3", "https://github.com/thegamerx1/ahk-libs", true)
		ctx.reply(embed)
	}
}
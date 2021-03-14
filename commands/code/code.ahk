class command_code extends DiscoBase.command {
	cooldown := 4
	info := "Gets code of a command"
	aliases := ["source"]
	args := [{optional: true, name: "command"}]

	call(ctx, args) {
		if !args[1] {
			embed := new discord.embed("", "", 0x3E4BBB)
			embed.addField("Source code", "https://github.com/thegamerx1/discord-bot")
			embed.addField("Made with Discord.ahk", "https://github.com/thegamerx1/ahk-libs/blob/master/Discord.ahk")
			ctx.reply(embed)
			return
		}

		command := this.bot.getAlias(args[1])
		if !command
			this.except(ctx, "Command not found")

		try {
			code := FileOpen(includer.list[command ".ahk"].path, "r", "UTF-8").read()
		} catch e {
			this.except(ctx, "Error reading file")
		}
		page := new discord.paginator(code)
		for _, value in page.get()
			ctx.reply("``````autoit`n" value  "``````")
	}
}
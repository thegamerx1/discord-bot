class command_code extends DiscoBot.command {
	static cooldown := 2
	, info := "Gets code of a command"
	, aliases := ["source"]
	, args := [{optional: true, name: "command"}]
	, category := "Code"


	call(ctx, args) {
		if !args[1] {
			embed := new discord.embed("", "", 0x3E4BBB)
			embed.addField("Source code", "https://github.com/thegamerx1/discord-bot")
			embed.addField("Made with Discord.ahk", "https://github.com/thegamerx1/ahk-libs")
			ctx.reply(embed)
			return
		}

		command := this.bot.getAlias(args[1])
		if !command
			return ctx.react("bot_no")

		try {
			code := FileOpen("commands\" command ".ahk", "r", "UTF-8").read()
		} catch e {
			this.except(ctx, "Command not found")
		}
		page := new discord.paginator(code)
		for _, value in page.pages
			ctx.reply("``````autoit`n" value  "``````")
	}
}
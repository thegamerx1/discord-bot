﻿class command_code extends command_ {
	static cooldown := 2
	, info := "Gets code of a command"
	, aliases := ["source"]
	, permissions := ["EMBED_LINKS"]
	, args := [{optional: true, name: "command"}]


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
		} catch {
			Throw Exception("File read failed to", command)
		}
		page := new discord.paginator(code)
		for _, value in page.pages
			ctx.reply("``````autoit`n" value  "``````")
	}
}
class command_code extends command_ {
	static cooldown := 2
	, info := "Gets code of a command"

	call(ctx, args) {
		if !args[1] {
			embed := new discord.embed()
			embed.setEmbed("My code is at", "https://github.com/thegamerx1/discord-bot`nhttps://github.com/thegamerx1/ahk-libs")
			ctx.reply(embed)
			return
		}

		command := this.bot.getAlias(args[1])
		if !command
			return ctx.react("bot_no")

		try {
			FileRead code, % "commands\" command ".ahk"
		} catch {
			Throw Exception("File read failed to", command)
		}

		ctx.reply("``````autoit`n" StrReplace(code, "``", "​``") "``````")
	}
}
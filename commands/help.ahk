class command_help extends command_ {
	static owneronly := false
	, cooldown := 4
	, info := "Prints info about a command"

	call(ctx, args) {
		if args[1] {
			info := this.bot.commands[args[1]].info
			embed := new discord.embed(args[1] ".ahk", info)
		} else {
			info := ""
			for key, value in this.bot.commands {
				info .= "``" key "`` - " value.info "`n"
			}
			embed := new discord.embed("Commands", info)
		}
		ctx.reply(embed)
	}
}
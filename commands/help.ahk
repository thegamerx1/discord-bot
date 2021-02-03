class command_help extends command_ {
	static owneronly := false
	, cooldown := 4
	, info := "Prints info about a command"

	call(ctx, args := "") {
		if args {
			info := this.bot.commands[args].info
			if !info {
				return ctx.react("❌")
			}
			embed := new discord.embed()
			embed.setEmbed("Command " args, "``" info "``")
			ctx.reply(embed)
		}
	}
}
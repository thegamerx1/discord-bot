class command_help extends command_ {
	static cooldown := 4
	, info := "Prints info about a command"
	, args := [{optional: true, name: "command"}]
	, permissions := ["EMBED_LINKS"]

	call(ctx, args, missing := false) {
		if args[1] {
			arg := ""
			aliases := ""
			args[1] := this.bot.getAlias(args[1])
			if !args[1]
				return ctx.react("bot_no")

			command := this.bot.commands[args[1]]
			for _, oarg in command.args {
				wraps := (oarg.optional) ? ["[", "]"] : ["<", ">"]
				arg .= " " wraps[1] oarg.name wraps[2] " "
			}

			for _, alias in command.aliases {
				aliases .= (aliases ? ", " : "") "_" alias "_"
			}

			embed := new discord.embed()
			embed.addField(args[1] " " arg, command.info)

			embed.addField("Aliases", aliases)
			if missing {
				embed.addField("There is a required argument missing", "<required> [optional]")
			}
		} else {
			embed := new discord.embed("Commands")
			for key, value in this.bot.commands {
				embed.addField(key, value.info, !!Mod(A_Index, 3))
			}
			ctx.author.sendDM(embed)
			embed := new discord.embed(,ctx.getEmoji("bot_ok") " Sent you a DM", 0xFF5959)
		}
		ctx.reply(embed)
	}
}
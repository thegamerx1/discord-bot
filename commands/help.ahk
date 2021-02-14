class command_help extends command_ {
	static cooldown := 4
	, info := "Prints help"
	, args := [{optional: true, name: "command"}]
	, category := "Bot"

	start() {
		this.categories := {}
		for name, cmd in this.bot.commands {
			if !cmd.category
				continue
			if !this.categories[cmd.category]
				this.categories[cmd.category] := []
			this.categories[cmd.category].push({name: name, info: cmd.info})
		}
	}

	call(ctx, args, missing := false) {
		if args[1] {
			arg := ""
			aliases := ""
			args[1] := this.bot.getAlias(args[1])
			if !args[1]
				return ctx.react("bot_no")

			cmd := this.bot.commands[args[1]]
			for _, oarg in cmd.args {
				wraps := (oarg.optional) ? ["[", "]"] : ["<", ">"]
				arg .= " " wraps[1] oarg.name wraps[2]
			}

			for _, alias in cmd.aliases {
				aliases .= (aliases ? ", " : "") alias
			}

			embed := new discord.embed(, (missing ? "**Argument missing: " cmd.args[missing].name "**`n" : "") cmd.info)
			embed.addField("Usage", args[1] " " arg)
			embed.setFooter("Aliases: " aliases)
		} else {
			embed := new discord.embed("Commands")
			index := 1
			for category, cmd in this.categories {
				index++
				if (!Mod(index, 2) && index != 2)
					embed.addField("", "",, true)
				out := ""
				for _, value in cmd {
					out .= "``" value.name "`` " value.info "`n"
				}
				embed.addField(category, out, true)
			}
			; ctx.author.sendDM(embed)
			; embed := new discord.embed(,ctx.getEmoji("bot_ok") " Sent you a DM", 0xFF5959)
		}
		ctx.reply(embed)
	}
}
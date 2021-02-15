class command_help extends DiscoBot.command {
	static cooldown := 4
	, args := [{optional: true, name: "command", type: "str"}]

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

	call(ctx, args, message := false, cmdargs := "", subname := false) {
		if args[1] {
			message := message ? "**" message "**`n" : ""
			args[1] := this.bot.getAlias(args[1])

			if !args[1]
				this.except(ctx, "Command not found")

			cmd := this.bot.commands[args[1]]

			aliases := ""
			for _, alias in cmd.aliases {
				aliases .= (aliases ? ", " : "") alias
			}

			cmdargs := cmdargs ? cmdargs : cmd.args
			embed := new discord.embed(, message cmd.info)`
			if message {
				usage := this.getCommand(args[1], cmdargs, subname)
			} else {
				usage := this.getCommand(args[1], cmd.args)
				for _, command in cmd.commands {
					usage .= this.getCommand(args[1], command.args, command.name)
				}
			}
			embed.addField("Usage", usage)

			embed.setFooter((aliases ? "Aliases: " aliases " " Chr(8226) " " : "") "Have questions? Join the support server with the support command!")
		} else {
			embed := new discord.embed("Commands")
			index := 1
			for category, cmd in this.categories {
				index++
				if (!Mod(index, 2) && index != 2)
					embed.addField("", "",, true)
				out := ""
				for _, value in cmd {
					out .= "***" value.name "*** " value.info "`n"
				}
				embed.addField(category, out, true)
			}
		}
		ctx.reply(embed)
	}

	getCommand(name, args, subname := "") {
		out := ""
		for _, arg in args {
			wraps := (arg.optional) ? ["[", "]"] : ["<", ">"]
			out .= " _" wraps[1] arg.name wraps[2] "_"
		}
		return "**" name "**" (subname ? " _" subname "_ " : "") out "`n"
	}
}
class command_command extends DiscoBase.command {
	cooldown := 2
	info := "Manage bot commands"
	aliases := ["cmd"]
	userperms := ["ADMINISTRATOR"]
	commands := [{name: "disable", args: [{name: "command"}]}
				,{name: "enable", args: [{name: "command"}]}
				,{name: "enableall"}
				,{name: "disableall"}]

	E_COMMAND_EXECUTE(data) {
		if contains(data.command, data.ctx.guild.data.disabled_commands) {
			this.except(data.ctx, "That command is disabled on this guild!", false)
			return 1
		}
	}

	c_disableall(ctx) {
		for name in this.bot.commands {
			if this.isInBlacklist(name)
				continue
			ctx.guild.data.disabled_commands.push(name)
		}
		ctx.react(this.bot.randomCheck())
	}

	c_enableall(ctx) {
		for name in this.bot.commands {
			if this.isInBlacklist(name)
				continue
			ctx.guild.data.disabled_commands := []
		}
		ctx.react(this.bot.randomCheck())
	}

	c_disable(ctx, args) {
		command := this.bot.getAlias(args[1])
		if !command
			this.except(ctx, "Command not found!")

		if contains(command, ctx.guild.data.disabled_commands)
			this.except(ctx, "Already disabled!")

		if this.isInBlacklist(command)
			this.except(ctx, "You can't disable that command!")

		ctx.guild.data.disabled_commands.push(command)
		ctx.react(this.bot.randomCheck())
	}

	c_enable(ctx, args) {
		command := this.bot.getAlias(args[1])
		if !command
			this.except(ctx, "Command not found!")

		if !(index := contains(command, ctx.guild.data.disabled_commands))
			this.except(ctx, "Already enabled!")

		ctx.guild.data.disabled_commands.RemoveAt(index)
		ctx.react(this.bot.randomCheck())
	}

	call(ctx, args) {
		disabled := ""
		for _, cmd in ctx.guild.data.disabled_commands {
			disabled .= (disabled ? ", " : "") "``" cmd "``"
		}
		embed := new discord.embed("Disabled commands", disabled ? disabled : "No disabled commands")
		ctx.reply(embed)
	}

	isInBlacklist(str) {
		static blacklist := ["bot", "owner"]

		return contains(this.bot.commands[str].category, blacklist)
	}
}
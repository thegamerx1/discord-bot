class command_command extends DiscoBase.command {
	cooldown := 2
	info := "Manage bot commands"
	aliases := ["cmd"]
	userperms := ["ADMINISTRATOR"]
	commands := [{name: "disable", args: [{name: "command"}]}
				,{name: "enable", args: [{name: "command"}]}]

	E_COMMAND_EXECUTE(data) {
		if contains(data.command, data.ctx.guild.data.disabled_commands)
			return 1
	}

	c_disable(ctx, args) {
		command := this.bot.getAlias(args[1])
		if !command
			this.except(ctx, "Command not found!")

		if contains(command, ctx.guild.data.disabled_commands)
			this.except(ctx, "Already disabled!")

		if (this.bot.commands[command].category = "bot")
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
		embed := new discord.embed("Commands")
		disabled := ""
		for _, cmd in ctx.guild.data.disabled_commands {
			disabled .= cmd "`n"
		}
		embed.addField("Disabled", disabled)
		ctx.reply(embed)
	}
}
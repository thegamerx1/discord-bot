class command_command extends DiscoBase.command {
	cooldown := 2
	info := "Manage bot commands"
	aliases := ["cmd"]
	userperms := ["ADMINISTRATOR"]
	commands := [{name: "disable", args: [{name: "command"}]}
				,{name: "enable", args: [{name: "command"}]}]

	E_COMMAND_EXECUTE(data) {
		if contains(data.command, data.ctx.data.disabled_commands)
			return 1
	}

	c_disable(ctx, args) {
		if contains(args[1], ctx.data.disabled_commands)
			this.except(ctx, "Already disabled!")

		ctx.data.disabled_commands.push(args[1])
		ctx.react(this.bot.randomCheck())
	}

	c_enable(ctx, args) {
		if !(index := contains(args[1], ctx.data.disabled_commands))
			this.except(ctx, "Already enabled!")

		ctx.data.disabled_commands.RemoveAt(index)
		ctx.react(this.bot.randomCheck())
	}

	call(ctx, args) {
		embed := new discord.embed("Commands")
		disabled := ""
		for _, cmd in ctx.data.disabled_commands {
			disabled .= cmd "`n"
		}
		embed.addField("Disabled", disabled)
		ctx.reply(embed)
	}
}
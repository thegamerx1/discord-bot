class command_remind extends DiscoBase.command {
	cooldown := 3
	info := "Creates and manages reminds"
	permissions := ["MANAGE_MESSAGES"]
	commands := [{name: "create", args: [{name: "when"}, {name: "message"}]}
				,{name: "delete", args: [{name: "index"}]}
				,{name: "list"}]

	isSubOnly := true
	static REMIND_LIMIT := 5
		; TODO: PARSE TIME
	; E_ready() {
	; }

	c_create(ctx, args) {
		if ctx.author.data.reminds.length > this.REMIND_LIMIT
			this.except(ctx, "You can't have more than ``" this.REMIND_LIMIT "`` reminds!")

		ctx.author.data.reminds.push({guild: ctx.guild.id, message: args[2], when: args[1]})
		ctx.react(this.bot.randomCheck())
	}

	c_delete(ctx, args) {
		if !ctx.author.data.reminds[args[1]]
			this.except(ctx, "Remind not found!")

		ctx.author.data.RemoveAt(args[1])
		ctx.react(this.bot.randomCheck())
	}

	c_list(ctx) {
		out := ""
		for i, remind in ctx.author.data.reminds {
			out .= i " - ``" Truncate(remind.message, 20) "```n"
		}
		embed := new discord.embed("Your reminds", !out ? "No reminds" : out)
		ctx.reply(embed)
	}
}
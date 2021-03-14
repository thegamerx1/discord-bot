class command_todo extends DiscoBase.command {
	cooldown := 3
	info := "Creates and manages todos"
	permissions := ["MANAGE_MESSAGES"]
	commands := [{name: "add", args: [{name: "description"}]}
				,{name: "done", args: [{name: "index"}]}
				,{name: "delete", args: [{name: "index"}]}
				,{name: "listdone"}]

	static TODO_LIMIT := 50

	c_add(ctx, args) {
		if ctx.author.data.todos.length > this.TODO_LIMIT
			this.except(ctx, "You can't have more than ``" this.TODO_LIMIT "`` todos!")

		ctx.author.data.todos.push(args[1])
		ctx.react(this.bot.randomCheck())
	}

	c_delete(ctx, args) {
		if !ctx.author.data.todos[args[1]]
			this.except(ctx, "Todo not found!")

		ctx.author.data.todos.RemoveAt(args[1])
		ctx.react(this.bot.randomCheck())
	}

	c_done(ctx, args) {
		if !ctx.author.data.todos[args[1]]
			this.except(ctx, "Todo not found!")

		todo := ctx.author.data.todos.RemoveAt(args[1])
		ctx.author.data.todos_done.push(todo)
		ctx.react(this.bot.randomCheck())
	}

	c_listdone(ctx) {
		out := ""
		for i, todo in ctx.author.data.todos_done {
			out .= i " - ``" Truncate(todo, 70) "```n"
		}
		embed := new discord.embed("Your done todos", out)
		ctx.reply(embed)
	}

	call(ctx) {
		static msg := "Todos done: ``{}```n{}"
		out := ""
		for i, todo in ctx.author.data.todos {
			out .= i " - ``" Truncate(todo, 70) "```n"
		}
		embed := new discord.embed("Your todos", format(msg,ctx.author.data.todos_done.length(), !out ? "Yay you have no todos" : out))
		ctx.reply(embed)
	}
}
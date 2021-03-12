class command_purge extends DiscoBase.command {
	cooldown := 3
	info := "Deletes messages"
	permissions := ["MANAGE_MESSAGES", "VIEW_CHANNEL"]
	userperms := ["MANAGE_MESSAGES"]
	args := [{optional: false, name: "count", type: "int"}]
	commands := [{name: "until", args: [{name: "id", type: "int"}]}]


	C_until(ctx, args) {
		try {
			ids := this.getMessages(ctx, {limit: 100, after: args[1]})
			ctx.channel.deleteMessage(ids)
		} catch e {
			this.except(ctx, e.message)
		}

		TimeOnce(ObjBindMethod(ctx, "delete"), 500)
	}

	call(ctx, args) {
		if (Between(args[1], 1, 100))
			this.except(ctx, "Count must be between 1 and 100!")

		try {
			ids := this.getMessages(ctx, {limit: args[1], before: ctx.id})
			ctx.channel.deleteMessage(ids)
		} catch e {
			this.except(ctx, e.message)
		}

		TimeOnce(ObjBindMethod(ctx, "delete"), 500)
	}

	getMessages(ctx, opt) {
		messages := ctx.channel.GetMessages(opt)
		ids := []
		for _, msg in messages {
			if msg.id = ctx.id
				continue
			ids.push(msg.id)
		}
		return ids
	}
}
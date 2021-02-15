class command_purge extends DiscoBot.command {
	static info := "Deletes messages"
	, permissions := ["MANAGE_MESSAGES", "VIEW_CHANNEL"]
	, userperms := ["MANAGE_MESSAGES"]
	, args := [{optional: false, name: "count", type: "int"}]
	, category := "Moderation"
	, commands := [{name: "until", args: [{name: "id", type: "int"}]}]


	C_until(ctx, args) {
		try {
			ids := this.getMessages(ctx, {limit: 100, after: args[1]})
			ctx.api.BulkDelete(ctx.channel.id, ids)
		} catch e {
			this.except(ctx, e.message)
		}

		ctx.react("bot_ok")
		TimeOnce(ObjBindMethod(ctx, "delete"), 500)
	}

	call(ctx, args) {
		if (Between(args[1], 2, 100))
			this.except(ctx, "Count must be between 2 and 100!")

		try {
			ids := this.getMessages(ctx, {limit: args[1], before: ctx.id})
			ctx.api.BulkDelete(ctx.channel.id, ids)
		} catch e {
			this.except(ctx, e.message)
		}

		ctx.react("bot_ok")
		TimeOnce(ObjBindMethod(ctx, "delete"), 500)
	}

	getMessages(ctx, opt) {
		messages := ctx.api.GetMessages(ctx.channel.id, opt)
		ids := []
		for _, value in messages {
			if value.id = ctx.id
				continue
			ids.push(value.id)
		}
		if (ids.length() < 2)
			this.except(ctx, "Error getting messages")
		return ids
	}
}
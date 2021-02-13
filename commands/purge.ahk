class command_purge extends command_ {
	static info := "Deletes messages"
	, permissions := ["MANAGE_MESSAGES", "VIEW_CHANNEL"]
	, userperms := ["MANAGE_MESSAGES"]
	, args := [{optional: false, name: "count"}]
	, category := "Moderation"


	call(ctx, args) {
		if (args[1] > 100 || args[1] < 2)
			return ctx.reply("Invalid amount")

		try {
			messages := ctx.api.GetMessages(ctx.channel.id, {limit: args[1], before: ctx.id})
			ids := []
			for _, value in messages
				ids.push(value.id)

			ctx.api.BulkDelete(ctx.channel.id, ids)
		} catch e {
			embed := new discord.embed()
			embed.addField("Error " e.message, e.what)
			return ctx.reply(embed)
		}
		TimeOnce(ObjBindMethod(this, "deleteSource", ctx), 1500)
		ctx.react("bot_ok")
	}

	deleteSource(ctx) {
		ctx.delete()
	}
}
class command_google extends command_ {
	static cooldown := 4
	, info := "Prints google"
	, aliases := ["notaprank"]
	, args := [{name: "query", optional: false}]
	, category := "Fun"


	call(ctx, args) {
		ctx.typing()
		TimeOnce(ObjBindMethod(this, "send", ctx, args[1]), 1000)
	}

	send(ctx, query) {
		msg := ctx.reply(new discord.embed(,ctx.getEmoji("bot_loading") " " query))
		TimeOnce(ObjBindMethod(msg, "edit", new discord.embed(, ctx.getEmoji("bot_loading") " Parsing results")), 4000)
		TimeOnce(ObjBindMethod(msg, "edit", new discord.embed(ctx.getEmoji("bot_ok") " Unsucesffuly didn't got google results:", ctx.getEmoji("bot_loading"))), 4000+6000)
	}
}
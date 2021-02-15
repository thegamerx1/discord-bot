class command_avatar extends DiscoBot.command {
	static cooldown := 1
	, info := "Shows 4k pfp of user"
	, args := [{optional: true, name: "user"}]


	call(ctx, args) {
		try {
			id := discord.utils.getid(args[1])
			ctx.reply(ctx.author.get(id ? id : ctx.author.id).avatar)
		} catch e {
			this.except(ctx, "Unkown user")
		}
	}
}
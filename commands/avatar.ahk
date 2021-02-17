class command_avatar extends DiscoBot.command {
	cooldown := 2
	info := "Shows 4k pfp of user"
	args := [{optional: true, name: "user"}]
	category := "Fun"

	call(ctx, args) {
		try {
			id := discord.utils.getid(args[1])
			ctx.reply(ctx.author.get(id ? id : ctx.author.id).avatar)
		} catch e {
			this.except(ctx, "Unkown user")
		}
	}
}
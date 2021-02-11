class command_nick extends command_ {
	static info := "Changes bot nick"
	, args := [{optional: true, name: "nick"}]
	, permissions := ["ADD_REACTIONS"]
	, userperms := ["MANAGE_NICKNAMES"]


	call(ctx, args) {
		nick := args[1] ? args[1] : ctx.api.self.username
		ctx.api.changeSelfNick(ctx.guild.id, nick)
		ctx.react("bot_ok")
	}
}
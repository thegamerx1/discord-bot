class command_nick extends command_ {
	static owneronly := true
	, info := "Changes bot nick"
	, args := [{optional: true, name: "nick"}]

	call(ctx, args) {
		nick := args[1] ? args[1] : ctx.api.user_name
		ctx.api.changeSelfNick(ctx.guild.id, nick)
		ctx.react("bot_ok")
	}
}
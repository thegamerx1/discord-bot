class command_nick extends DiscoBot.command {
	static info := "Changes bot nickname"
	, args := [{optional: true, name: "nick"}]
	, userperms := ["MANAGE_NICKNAMES"]
	, category := "Bot"


	call(ctx, args) {
		nick := args[1] ? args[1] : ctx.api.self.username
		ctx.api.changeSelfNick(ctx.guild.id, nick)
		ctx.react("bot_ok")
	}
}
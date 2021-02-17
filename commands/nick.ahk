class command_nick extends DiscoBot.command {
	cooldown := 2
	info := "Changes bot nickname"
	args := [{optional: true, name: "nick"}]
	userperms := ["MANAGE_NICKNAMES"]
	category := "Owner"

	call(ctx, args) {
		nick := args[1] ? args[1] : ctx.api.self.username
		ctx.api.changeSelfNick(ctx.guild.id, nick)
		ctx.react(this.bot.randomCheck())
	}
}
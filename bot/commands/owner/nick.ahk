class command_nick extends DiscoBase.command {
	info := "Changes bot nickname"
	args := [{optional: true, name: "nick"}]
	owneronly := true

	call(ctx, args) {
		nick := args[1] ? args[1] : ctx.api.self.username
		ctx.api.changeSelfNick(ctx.guild.id, nick)
		ctx.react(this.bot.randomCheck())
	}
}
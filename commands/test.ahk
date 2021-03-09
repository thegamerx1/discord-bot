class command_test extends DiscoBot.command {
	owneronly := true
	category := "Owner"

	call(ctx, args) {
		msg := ctx.api.getMessage(ctx.channel.id, ctx.id)
		msg.react("loading")
		msg.unReact("loading")
	}
}
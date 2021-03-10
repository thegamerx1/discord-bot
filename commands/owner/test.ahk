class command_test extends DiscoBase.command {
	owneronly := true

	call(ctx, args) {
		msg := ctx.api.getMessage(ctx.channel.id, ctx.id)
		msg.react("loading")
		msg.unReact("loading")
	}
}
class command_exit extends DiscoBase.command {
	owneronly := true
	info := "Exits the bot safely"

	call(ctx, args) {
		ctx.api.delete()
		exitapp 0
	}
}
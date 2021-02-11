class command_exit extends command_ {
	static owneronly := true
	, info := "Exits the bot safely"

	call(ctx, args) {
		ctx.api.disconnect()
		exitapp 0
	}
}
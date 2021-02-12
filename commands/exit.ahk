class command_exit extends command_ {
	static owneronly := true

	call(ctx, args) {
		ctx.api.disconnect()
		exitapp 0
	}
}
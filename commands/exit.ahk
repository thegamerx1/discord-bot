class command_exit extends DiscoBot.command {
	owneronly := true
	info := "Exits the bot safely"
	category := "Owner"

	call(ctx, args) {
		ctx.api.disconnect()
		exitapp 0
	}
}
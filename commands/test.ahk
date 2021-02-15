class command_test extends DiscoBot.command {
	static owneronly := true

	call(ctx, args) {
		throw "no"
		ctx.reply("no?")
	}
}
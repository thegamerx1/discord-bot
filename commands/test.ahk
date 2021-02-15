class command_test extends DiscoBot.command {
	static owneronly := true
	, category := "owner"

	call(ctx, args) {
		throw "no"
		ctx.reply("no?")
	}
}
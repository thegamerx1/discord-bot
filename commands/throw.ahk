class command_throw extends DiscoBot.command {
	owneronly := true
	info := "Throws exception for debugging"
	category := "Owner"
	commands := [{name: "exception"}]

	c_exception(ctx, args) {
		this.except(ctx, args[1])
	}

	call(ctx, args) {
		throw args[1]
	}
}
class command_throw extends DiscoBase.command {
	owneronly := true
	info := "Throws exception for debugging"
	commands := [{name: "exception"}]

	c_exception(ctx, args) {
		this.except(ctx, args[1])
	}

	call(ctx, args) {
		throw args[1]
	}
}
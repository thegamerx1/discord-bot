class command_prefix extends DiscoBase.command {
	cooldown := 2
	disabled := true
	info := "Sets server prefix for the bot"
	args := [{optional: false, name: "prefix"}]
	permissions := ["CHANGE_NICKNAME"]
	userperms := ["ADMINISTRATOR"]

	call(ctx, args) {
		length := StrLen(args[1])
		if !Between(length, 1,3)
			this.except(ctx, "Prefix must be between 1 and 3 characters!")

		ctx.data.prefix := args[1]
		ctx.react(this.bot.randomCheck())
	}
}
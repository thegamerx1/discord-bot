class command_unban extends DiscoBase.command {
	cooldown := 5
	info := "Unbans a user"
	permissions := ["BAN_MEMBERS"]
	userperms := ["BAN_MEMBERS"]
	args := [{optional: false, name: "user"}]

	call(ctx, args) {
		try {
			ctx.api.RemoveBan(ctx.guild.id, discord.utils.getId(args[1]))
		} catch e {
			this.except(ctx, e.message)
		}
		ctx.react(this.bot.randomCheck())
	}
}
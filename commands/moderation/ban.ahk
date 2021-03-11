class command_ban extends DiscoBase.command {
	cooldown := 3
	info := "Bans a user"
	permissions := ["BAN_MEMBERS"]
	userperms := ["BAN_MEMBERS"]
	args := [{optional: false, name: "user"}
				,{optional: true, name: "reason", type: "str"}]

	call(ctx, args) {
		id := discord.utils.getId(args[1])
		if (id = ctx.api.self.id) {
			ctx.react("success")
			ctx.api.LeaveGuild(ctx.guild.id)
			return
		}

		try {
			ctx.guild.ban(id, args[2], 0)
		} catch e {
			this.except(ctx, e.message)
		}
		ctx.react("success")
	}
}
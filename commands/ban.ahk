class command_ban extends DiscoBot.command {
	static cooldown := 1
	, info := "Bans a user"
	, permissions := ["BAN_MEMBERS"]
	, userperms := ["BAN_MEMBERS"]
	, args := [{optional: false, name: "user"}
				,{optional: true, name: "reason", type: "str"}]
	, category := "Moderation"


	call(ctx, args) {
		id := discord.utils.getId(args[1])
		if (id = ctx.api.self.id) {
			ctx.react("bot_ok")
			ctx.api.LeaveGuild(ctx.guild.id)
			return
		}

		try {
			ctx.api.AddBan(ctx.guild.id, id, args[2], 0)
		} catch e {
			this.except(ctx, e.message)
		}
		ctx.react("bot_ok")

	}
}
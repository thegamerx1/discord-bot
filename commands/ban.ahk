class command_ban extends command_ {
	static cooldown := 1
	, info := "Bans a user"
	, permissions := ["BAN_MEMBERS"]
	, userperms := ["BAN_MEMBERS"]
	, args := [{optional: false, name: "user"}
				,{optional: true, name: "reason"}]
	, category := "Moderation"


	call(ctx, args) {
		try {
			ctx.api.AddBan(ctx.guild.id, discord.utils.getId(args[1]), args[2], 0)
		} catch e {
			embed := new discord.embed("Error", e.message)
			ctx.reply(embed)
			return
		}
		ctx.react("bot_ok")

	}
}
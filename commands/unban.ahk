class command_unban extends command_ {
	static cooldown := 1
	, info := "Unbans a user"
	, permissions := ["BAN_MEMBERS"]
	, userperms := ["BAN_MEMBERS"]
	, args := [{optional: false, name: "user"}]
	, category := "Moderation"


	call(ctx, args) {
		try {
			ctx.api.RemoveBan(ctx.guild.id, discord.utils.getId(args[1]))
		} catch e {
			embed := new discord.embed("Error", e.message)
			ctx.reply(embed)
			return
		}
		ctx.react("bot_ok")
	}
}
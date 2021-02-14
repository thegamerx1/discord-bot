class command_prefix extends command_ {
	static owneronly := true
	, info := "Gets code from github"
	, category := "Owner"

	call(ctx, args) {
		try {
			output := RunCMD("../pullall.cmd")
		} catch e {
			Throw Exception(e.message, e.what, 400)
		}
		ctx.reply("``````" discord.utils.sanitize(output) "``````")
	}
}
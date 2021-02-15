class command_logs extends DiscoBot.command {
	static owneronly := true
	, info := "Gets bot logs"
	, args := [{optional: true, name: "lines", default: 20}]
	, category := "Owner"

	call(ctx, args) {
		ctx.reply("``````prolog`n" discord.utils.sanitize(strGetLast(debug.log, args[1])) "``````")
	}
}
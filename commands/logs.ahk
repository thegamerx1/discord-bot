class command_logs extends command_ {
	static owneronly := true
	,args := [{optional: true, name: "length", default: 400}]

	call(ctx, args) {
		ctx.reply("``````prolog`n" discord.utils.sanitize(strGetLast(debug.log, args[1])) "``````")
	}
}
class command_logs extends DiscoBot.command {
	owneronly := true
	info := "Gets bot logs"
	args := [{optional: true, name: "lines", default: 20}]
	category := "Owner"

	call(ctx, args) {
		pag := new discord.paginator(strGetLast(debug.log, args[1]))
		for _, page in pag {
			ctx.reply(discord.utils.codeblock("prolog", page))
		}
	}
}
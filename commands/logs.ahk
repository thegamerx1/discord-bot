class command_logs extends DiscoBot.command {
	owneronly := true
	info := "Gets bot logs"
	args := [{optional: true, name: "lines", default: 20}]
	category := "Owner"

	call(ctx, args) {
		logs := strGetLast(debug.log, args[1])
		if !logs
			this.except(ctx, "Logs brokey")
		pag := new discord.paginator(logs)
		for _, page in pag.get() {
			ctx.reply(discord.utils.codeblock("prolog", page))
		}
	}
}
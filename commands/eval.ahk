class command_eval extends command_ {
	static owneronly := true
	, args := [{optional: false, name: "query"}]
	, aliases := ["print"]


	call(ctx, args) {
		if !this.bot.bot.release
			clipboard := ctx.message
		msg := ctx.referenced_msg ? ctx.referenced_msg : ctx
		data := msg[StrSplit(args[1], ".")*]
		if IsObject(data) {
			output := JSON.dump(data,0,1)
			if (StrLen(output) > 1400) {
				temp := ""
				for key, value in data {
					temp .= (IsObject(key) ? "{}" : key) ": " (IsObject(value) ? "{}" : value)  "`n"
				}
				output := temp
			}
		} else {
			output := data
		}
		pages := new discord.paginator(output)
		for _, page in pages.pages {
			ctx.reply("``````json`n" page  "``````")
		}
	}
}
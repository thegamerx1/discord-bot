class command_eval extends command_ {
	static owneronly := true
	, info := "Gets output of a message"
	, args := [{optional: false, name: "query"}]
	, aliases := ["print"]

	call(ctx, args) {
		clipboard := "-eval " args[1]
		msg := ctx.referenced_msg ? ctx.referenced_msg : ctx
		data := msg[StrSplit(args[1], ".")*]
		if IsObject(data) {
			output := JSON.dump(data,0,1)
			if (StrLen(output) > 1400) {
				temp := "`n"
				for key, value in data {
					temp .= (IsObject(key) ? "{}" : key) ": " (IsObject(value) ? "{}" : value)  "`n"
				}
				output := "Keys: " temp
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
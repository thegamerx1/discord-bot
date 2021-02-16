class command_eval extends DiscoBot.command {
	static owneronly := true
	, args := [{name: "query"}]
	, aliases := ["print"]
	, category := "Owner"
	, commands := [{name: "msg", args: [{name: "msg", type: "int"}, {name: "query"}]}]

	call(ctx, args) {
		if !this.SET.release
			clipboard := ctx.message
		data := eval(args[1], [{name: "ctx", val: ctx}, {name: "reply", val: ctx.referenced_msg}])
		if IsObject(data) {
			deep := ObjectDeep(data, 500)
			if (deep > 50) {
				if deep > 190
					this.except(ctx, "Result is too deep!")

				output := this.beutifolObj(data)
			} else {
				output := JSON.dump(data,0,1)
				if (StrLen(output) > 1400)
					output := this.beutifolObj(data)
			}
		} else {
			output := data
		}

		pages := new discord.paginator(output)
		for _, page in pages.pages {
			ctx.reply(discord.utils.codeblock("json", page, false, "No output bu"))
		}
	}

	beutifolObj(obj) {
		temp := ""
		for key, value in obj {
			temp .= (IsObject(key) ? "{}" : key) ": " (IsObject(value) ? "{}" : value)  "`n"
		}
		return temp
	}
}
class command_eval extends DiscoBot.command {
	owneronly := true
	args := [{name: "query"}]
	aliases := ["print"]
	category := "Owner"
	commands := [{name: "msg", args: [{name: "msg", type: "int"}, {name: "query"}]}]

	c_msg(ctx, args) {
		if !this.SET.release
			clipboard := ctx.message

		msg := ctx.api.GetMessage(ctx.channel.id, args[1])
		this.printee(ctx, eval(discord.utils.getCodeBlock(args[2]).code, [{name: "ctx", val: msg}]))
	}

	call(ctx, args) {
		this.printee(ctx, eval(discord.utils.getCodeBlock(args[1]).code, [{name: "ctx", val: ctx}, {name: "reply", val: ctx.referenced_msg}, {name: "bot", val: this.bot}]))
	}

	printee(ctx, data) {
		if !this.SET.release
			clipboard := ctx.message
		if IsObject(data) {
			deep := ObjectDeep(data, 200)
			if (deep > 60) {
				if deep > 190
					this.except(ctx, "Result is too deep!")

				output := this.beutifolObj(data)
			} else {
				output := JSON.dump(data,0,1)
				if (StrLen(output) > 1800)
					output := this.beutifolObj(data)
			}
		} else {
			output := data
		}

		if !output
			return ctx.react("empty")

		if StrLen(output) < 100 {
			ctx.reply(output)
			return
		}

		pages := new discord.paginator(output)
		for _, page in pages.get() {
			ctx.reply(discord.utils.codeblock("json", page, false, "No output"))
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
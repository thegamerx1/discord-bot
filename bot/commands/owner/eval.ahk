class command_eval extends DiscoBase.command {
	owneronly := true
	args := [{name: "query"}]
	aliases := ["print"]
	commands := [{name: "msg", args: [{name: "msg", type: "int"}, {name: "query"}]}]

	c_msg(ctx, args) {
		msg := ctx.channel.GetMessage(args[1])
		this.printee(ctx, eval(discord.utils.getCodeBlock(args[2]).code, [{name: "ctx", val: msg}]))
	}

	call(ctx, args) {
		this.printee(ctx, eval(discord.utils.getCodeBlock(args[1]).code, [{name: "ctx", val: ctx}, {name: "reply", val: ctx.reply_msg}, {name: "bot", val: this.bot}]))
	}

	printee(ctx, data) {
		if IsObject(data) {
			deep := ObjectDeep(data, 200)
			if (deep > 60) {
				output := this.beutifolObj(data)
			} else {
				output := JSON.dump(data,0,1)
				if (StrLen(output) > 1800)
					output := this.beutifolObj(data)
			}
		} else {
			output := data
		}

		if (output = "")
			return ctx.react("empty")

		ctx.delete()
		file := new discord.messageFile("json", output, "````" discord.utils.sanitize(ctx.content) "````")
		msg := ctx.reply(file)
		msg.react("trash")
	}

	beutifolObj(obj) {
		temp := ""
		for key, value in obj {
			temp .= (IsObject(key) ? "{}" : key) ": " (IsObject(value) ? "{}" : value)  "`n"
		}
		return temp
	}

	E_MESSAGE_REACTION_ADD(ctx) {
		if (ctx.emoji == "trash") {
			if (ctx.message.author.id = ctx.api.self.id)
				if (ctx.author.id = ctx.api.owner.id)
					ctx.message.delete()
		}
	}
}
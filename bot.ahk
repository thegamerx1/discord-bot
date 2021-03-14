class DiscoBot {
	init() {
		this.commands := this.cache := {}
		FileCreateDir data
		this.bot := new configLoader("data/settings.json",, true)
		this.default := new configLoader("data/default.json",, true)
		this.settings := new configLoader("data/global.json")
		this.data := new configLoader("data/data.json")

		if this.bot.release
			debug.attachFile := "log.log"

		this.loadData()
		this.loadCommands()
		if (A_Args[1] = "-reload")
			this.resume := StrSplit(A_Args[2], ",")

 		this.api := new Discord(this, this.bot.token, this.bot.intents, this.bot.owner.guild, this.bot.owner.id)
		save := ObjBindMethod(this.data, "save")
		OnExit(save), SetTimer(save, 60*30*1000)
	}

	E_READY() {
		this.api.SetPresence("online", this.settings.data.prefix " help", 2)
		debug.print("READY!")
	}

	_event(event, data) {
		fn := this["E_" event]
		capture := false
		for key, value in this.commands
			if this.executeCommand(key, "_event", event, data)
				capture := true

		if !capture
			%fn%(this, data)
	}

	getGuild(id) {
		if !contains(id, this.data.data.guild, 1)
			this.data.data.guild[id] := clone(this.default.guild)

		return this.data.data.guild[id]
	}

	getUser(id) {
		if !contains(id, this.data.data.user, 1)
			this.data.data.user[id] := clone(this.default.user)

		return this.data.data.user[id]
	}

	loadData() {
		for id, data in this.data.data.guild {
			this.data.data.guild[id] := EzConf(data, this.default.guild)
		}
		debug.print("Loaded " this.data.data.guild.count() " guilds")
		for id, data in this.data.data.user {
			this.data.data.user[id] := EzConf(data, this.default.user)
		}
		debug.print("Loaded " this.data.data.user.count() " users")
	}

	loadCommands() {
		for _, file in includer.list {
			name := file.name
			rawcmd := new Command_%name%(this)
			if rawcmd.disabled
				continue
			command := "Command_" name
			rawcmd.category := file.folder
			this.commands[name] := rawcmd
		}
		for name, cmd in this.commands {
			this.executeCommand(name, "start")
		}
		this.cache.aliases := {}
		for cname, value in this.commands {
			this.cache.aliases[cname] := cname

			; ? Search in command aliases
			for _, aname in value.aliases {
				this.cache.aliases[aname] := cname
			}
		}
		debug.print("Loaded " this.commands.count() " commands")
	}

	E_GUILD_DELETE(data) {
		if data.unavailable
			return
		this.guilds.data.delete(data.id)
	}

	getAlias(name) {
		return this.cache.aliases[name]
	}

	executeCommand(command, func, args*) {
		fn := this.commands[command][func]
		return %fn%(this.commands[command], args*)
	}

	printError(ctx, e) {
		static source := "**{}:** {} ({})"
		static source1 := "**{}:** {}"
		embed := new discord.embed("Exception", discord.utils.codeblock("js", ctx.content), "error")
		out := format(source, "Guild", ctx.guild.name, ctx.guild.id) "`n" format(source, "User", ctx.author.mention, ctx.author.id)
		out .= "`n" format(source1, "Message", e.message) "`n" format(source1, "What", e.what) "`n" format(source1, "Extra", e.extra)
		embed.addField("Exception", out)
		embed.addField("File", "``" e.file "`` (" e.line ")")
		embed.setFooter("Error ID: " e.errorid)
		discord.utils.webhook(embed, this.bot.webhooks.error)
	}

	randomCheck() {
		static checks := ["check", "success", Unicode.get("white_check_mark"), Unicode.get("check_box_with_check")]
		return random(checks)
	}

	E_MESSAGE_CREATE(ctx) {
		static bot_what := ["what", "angry", Unicode.get("question"), Unicode.get("grey_question"), "blobpeek", "happythonk", "confuseddog", Unicode.get("eyes")]
		static pingPrefix := "My prefix is ``{1}```n***{1}help*** for help menu!`n***{1}help*** **<command>** for command description!"

		if ctx.author.bot
			return

		ctx.guild.data := this.getGuild(ctx.guild.id)
		ctx.author.data := this.getUser(ctx.author.id)

		isPing := StartsWith(ctx.content, "<@!" this.api.self.id ">")
		if (isPing || StartsWith(ctx.content, this.settings.data.prefix)) {
			data := StrSplit(SubStr(ctx.content, StrLen(this.settings.data.prefix)+1), [" ", "`n"],, 2+isPing)

			if isPing
				data.RemoveAt(1)

			command := this.getAlias(data[1])

			if (!command && isPing && ctx.channel.canI(["SEND_MESSAGES"]))
				return ctx.reply(new discord.embed(, format(pingPrefix, this.settings.data.prefix)))

			if (!command && ctx.channel.canI(["ADD_REACTIONS"]))
				return ctx.react(random(bot_what))

			this._event("COMMAND_EXECUTE", {command: command, ctx: ctx, data: data})
		}
	}

	E_COMMAND_EXECUTE(data) {
		try {
			this.executeCommand(data.command, "called", data.ctx, data.command, data.data[2])
		} catch e {
			ctx := data.ctx
			embed := new discord.embed("Oops!", "An error ocurred on the command and my developer has been notified.`n`nYou can you join the support server [here](" this.bot.owner.server_invite ")!", "error")
			embed.setFooter("Error ID: " e.errorid)
			ctx.reply(embed)
			this.printError(ctx, e)
		}
	}
}
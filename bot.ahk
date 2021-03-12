class DiscoBot {
	init() {
		this.commands := this.cache := {}
		FileCreateDir data
		this.bot := new configLoader("data/settings.json",, true)
		this.defaultconf := new configLoader("data/default.json",, true)
		this.settings := new configLoader("data/global.json")
		this.guilds := new configLoader("data/guilds.json")

		if this.bot.release
			debug.attachFile := "log.log"

		this.loadCommands()
		this.loadGuilds()
		if (A_Args[1] = "-reload")
			this.resume := StrSplit(A_Args[2], ",")

 		this.api := new Discord(this, this.bot.token, this.bot.intents, this.bot.owner.guild, this.bot.owner.id)
		OnExit(ObjBindMethod(this, "save"))
		SetTimer(ObjBindMethod(this, "save"), 60*30*1000)
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
		if !contains(id, this.guilds.data, 1)
			this.guilds.data[id] := clone(this.defaultconf)

		return this.guilds.data[id]
	}

	loadGuilds() {
		debug.print("|Loading guilds")
		for id, data in this.guilds.data {
			this.guilds.data[id] := EzConf(data, this.defaultconf)
		}
		debug.print("Loaded " this.guilds.data.count() " guilds")
	}

	loadCommands() {
		debug.print("|Loading commands")
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

	save() {
		this.guilds.save()
		this.settings.save()
	}

	executeCommand(command, func, args*) {
		fn := this.commands[command][func]
		return %fn%(this.commands[command], args*)
	}

	printError(ctx, e) {
		static source := "**{}:** {} ({})"
		static source1 := "**{}:** {}"
		embed := new discord.embed("Exception", discord.utils.codeblock("js", ctx.message), "error")
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
		debug.print(ctx.guild.data)

		isPing := StartsWith(ctx.message, "<@!" this.api.self.id ">")
		if (isPing || StartsWith(ctx.message, this.settings.data.prefix)) {
			data := StrSplit(SubStr(ctx.message, StrLen(this.settings.data.prefix)+1), [" ", "`n"],, 2+isPing)

			if isPing
				data.RemoveAt(1)

			command := this.getAlias(data[1])

			if (!command && isPing)
				return ctx.reply(new discord.embed(, format(pingPrefix, this.settings.data.prefix)))

			if (!command && contains("ADD_REACTIONS", ctx.self.permissions))
				return ctx.react(random(bot_what))

			this._event("COMMAND_EXECUTE", {command: command, ctx: ctx, data: data})
		}
	}

	E_COMMAND_EXECUTE(data) {
		try {
			this.executeCommand(data.command, "called", data.ctx, data.command, data.data[2])
		} catch e {
			embed := new discord.embed("Oops!", "An error ocurred on the command and my developer has been notified.`n`nYou can you join the support server [here](" this.bot.owner.server_invite ")!", "error")
			embed.setFooter("Error ID: " e.errorid)
			ctx.reply(embed)
			this.printError(ctx, e)
		}
	}
}
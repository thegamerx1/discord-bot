class DiscoBot {
	init() {
		this.guilds := this.commands := this.cache := {}
		botFile := new configLoader("settings.json")
		this.bot := botFile.data
		if this.bot.release
			debug.attachFile := "log.log"

		this.loadCommands()
		this.api := new Discord(this, this.bot.TOKEN, this.bot.INTENTS, this.bot.OWNER_GUILD_ID)
		this.api.setMirror(ObjBindMethod(this, "mirrorToExtension"))
		if (A_Args[1] == "-reload")
			this.resumedata := StrSplit(A_Args[2], ",", " ")

		OnExit(ObjBindMethod(this, "save"))
	}

	_event(event, data) {
		fn := this["E_" event]
		for key, value in this.commands
			this.executeCommand(key, "_event", event, data)
		Debug.print("|Event: " event)
		%fn%(this, data)
	}

	loadCommands() {
		debug.print("|Loading commands")
		for key, value in includer.list {
			command := "Command_" value
			this.commands[value] := new Command_%value%(this)
			this.executeCommand(value, "start")
		}
		this.cache.aliases := {}
		for cname, value in this.commands {
			this.cache.aliases[cname] := cname

			; ? Search in command aliases
			for _, aname in value.aliases {
				this.cache.aliases[aname] := cname
			}
		}
	}

	loadGuild(id) {
		this.guilds[id] := new configLoader("guildData/" id ".json", {prefix: this.bot.PREFIX})
	}

	E_GUILD_CREATE(data) {
		this.loadGuild(data.id)
	}

	getAlias(name) {
		return this.cache.aliases[name]
	}

	save() {
		for key, value in this.guilds {
			value.save()
		}
	}

	executeCommand(command, func, args*) {
		fn := this.commands[command][func]
		return %fn%(this.commands[command], args*)
	}

	E_ready(args*) {
		this.api.SetPresence("online", "Discord.ahk")
	}

	E_MESSAGE_CREATE(ctx) {
		static bot_what := ["bot_question", "bot_what", "bot_angry"]
		if ctx.author.bot
			return
		if (this.bot.release && ctx.author.id != this.bot.OWNER_ID)
			return

		prefix := this.guilds[ctx.guild.id].data.prefix
		isPing := (SubStr(ctx.message, 1, StrLen(this.api.self.id)+4) == "<@!" this.api.self.id ">")
		if (SubStr(ctx.message, 1, StrLen(prefix)) == prefix || isPing) {
			data := StrSplit(SubStr(ctx.message, StrLen(prefix)+1), [" ", "`n"],, 2+isPing)

			if isPing
				data.RemoveAt(1)

			command := this.getAlias(data[1])

			if (!command && isPing)
				return ctx.reply(new discord.embed(, "My prefix is ``" prefix "``"))

			if (!command && contains("ADD_REACTIONS", ctx.self.permissions))
				return ctx.react(random(bot_what))


			try {
				this.executeCommand(command, "called", ctx, command, data[2])
			} catch e {
				return this.printError(ctx, e)
			}
		}
	}

	printError(ctx, e) {
		channel := this.api.CreateDM(this.bot.OWNER_ID)
		embed := new discord.embed("Error on command", ctx.message, 0xFF5959)
		embed.addField("On Guild", ctx.guild.name " (" ctx.author.id ")")
		embed.addField("Issued by", ctx.author.name " (" ctx.author.id ")")
		embed.addField("Message", e.message)
		embed.addField("What", e.what)
		embed.addField("Extra", e.extra)
		embed.addField("File", "``" e.file "`` (" e.line ")")
		this.api.SendMessage(channel.id, embed)
	}
}

class command_ {
	__New(bot) {
		if !this.permissions
			this.permissions := []
		this.permissions.push("SEND_MESSAGES")
		this.permissions.push("ADD_REACTIONS")
		this.bot := bot
		this.cooldowns := {}
	}

	_event(event, data) {
		fn := this["E_" event]
		%fn%(this, data)
	}

	called(ctx, command, args := "") {
		static regex := "[^\s""']+|""([^""]+)"""
		author := ctx.author.id

		for _, value in this.permissions {
			if !contains(value, ctx.self.permissions) {
				if contains("SEND_MESSAGES", ctx.self.permissions) {
					ctx.reply("I need ``" value "`` for that!")
				}
				return
			}
		}

		for _, value in this.userperms {
			if !contains(value, ctx.author.permissions) {
				ctx.reply(new discord.embed(, "You don't have permissions to do that!"))
				return
			}

		}

		if (this.owneronly && this.bot.bot.OWNER_ID != author)
			return ctx.react("bot_notallowed")

		if (this.serverowneronly && ctx.author.id != ctx.guild.owner)
			return ctx.react("bot_notallowed")

		out := []
		loops := 0
		while match := regex(args, regex)
		{
			loops++
			if (loops >= this.args.length()) {
				out.push(args)
				break
			}
			args := StrReplace(args, match.value,,, 1)
			out.push(match[1] ? match[1] : match[0])
		}
		args := out

		for i, arg in this.args {
			if (args[1] = "") {
				if (arg.optional && arg.default != "")
					args[i] := arg.default

				if !arg.optional {
					this.bot.executeCommand("help", "call", ctx, [command], A_Index)
					return
				}
			}
		}
		if (this.cooldown && author != this.bot.bot.OWNER_ID) {
			if (this.cooldowns[author].time > A_TickCount) {
				if !this.cooldowns[author].reacted {
					this.cooldowns[author].reacted := true
					ctx.react("bot_cooldown")
				}
				return
			}

			this.setCooldown(author)
		}


		this.call(ctx, args)
	}

	setCooldown(author, time := "") {
		if !time
			time := this.cooldown
		this.cooldowns[author] := {time: A_TickCount + time * 1000, reacted: false}
	}
}

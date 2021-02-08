class DiscoBot {
	guilds := {}
	commands := {}
	init() {
		this.cache := {}
		botFile := new configLoader("settings.json")
		this.bot := botFile.data
		this.loadCommands()
		this.api := new Discord(this, this.bot.TOKEN, this.bot.INTENTS, this.bot.OWNER_GUILD_ID)
		this.api.setMirror(ObjBindMethod(this, "mirrorToExtension"))
		if (A_Args[1] == "-reload")
			this.resumedata := StrSplit(A_Args[2], ",", " ")

		OnExit(ObjBindMethod(this, "save"))
	}

	mirrorToExtension(event, data) {
		for key, value in this.commands
			this.executeCommand(key, "_event", event, data)
		this.executeCommand
	}

	loadCommands() {
		debug.print("Loading commands")
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
		this.cache.aliasarray := []
		this.cache.aliasmeans := []
		for aname, _ in this.cache.aliases
			this.cache.aliasarray.push(aname)
	}

	loadGuilds(guild := "") {
		debug.print("Loading guilds")
		Loop Files, guildData/*.json, F
			this.loadGuild(StrReplace(A_LoopFileName, ".json"))
	}

	loadGuild(id) {
		this.guilds[id] := new configLoader("guildData/" id ".json", {prefix: this.bot.PREFIX})
	}

	getAlias(name) {
		alias := this.cache.aliases[name]
		if alias
			return alias
		if this.cache.aliasmeans[name]
			return this.cache.aliasmeans[name]

		this.cache.aliasmeans[name] := stringDiffBest(this.cache.aliasarray, name)
		return this.getAlias(name)
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
		this.loadGuilds()

		this.api.SetPresence("online", "Discord.ahk")
	}

	E_MESSAGE_CREATE(ctx) {
		static bot_what := ["bot_question", "bot_what", "bot_angry", "bot_why"]
		if (ctx.author.bot)
			return

		prefix := this.guilds[ctx.data.guild_id].data.prefix
		isPing := (SubStr(ctx.message, 1, StrLen(this.api.USER_ID)+4) == "<@!" this.api.USER_ID ">")
		if (SubStr(ctx.message,1,1) == prefix || isPing) {
			data := StrSplit(SubStr(ctx.message, 2), [" ", "`n"],, 2+isPing)

			if isPing
				data.RemoveAt(1)
			command := this.getAlias(data[1])


			if (isObject(command) && isPing)
				command = help

			if isObject(command) {
				embed := new discord.embed("Did you mean?", command.str)
				embed.setFooter(command.percent "%")
				return ctx.reply(embed)
			}

			if !command
				return ctx.react(random(bot_what))


			try {
				debug.print(ctx.author.name " issued command " command " on " ctx.guild.name)
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

		for _, arg in this.args {
			if !arg.optional {
				if (args[A_Index] = "") {
					this.bot.executeCommand("help", "call", ctx, [command], true)
					return
				}
			}
		}
		if this.cooldown {
			if (this.cooldowns[author])
				return ctx.react("bot_cooldown")

			this.cooldowns[author] := true
			fn := ObjBindMethod(this, "removeCooldown", author)
			SetTimer %fn%, % "-" this.cooldown * 1000
		}

		this.call(ctx, args)
	}

	removeCooldown(author) {
		this.cooldowns[author] := false
	}
}

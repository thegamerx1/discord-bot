class DiscoBot {
	init() {
		this.guilds := {}
		this.commands := {}
		this.loadCommands()
		botFile := new configLoader("settings.json")
		this.bot := botFile.data
		this.api := new Discord(this, this.bot.TOKEN, this.bot.INTENTS, this.bot.OWNER_GUILD_ID)
		if (A_Args[1] == "-reload")
			this.resumedata := StrSplit(A_Args[2], ",", " ")

		OnExit(ObjBindMethod(this, "save"))
	}

	loadCommands() {
		debug.print("Loading commands")
		for key, value in includer.list {
			command := "Command_" value
			this.commands[value] := new Command_%value%(this)
		}
	}

	loadGuilds(guild := "") {
		debug.print("Loading guilds")
		Loop Files, guildData/*.json, F
			this.loadGuild(StrReplace(A_LoopFileName, ".json"))
	}

	loadGuild(id) {
		this.guilds[id] := new configLoader("guildData/" id ".json", {prefix: this.bot.PREFIX})
	}

	getAlias(command) {
		for key, value in this.commands {
			; * Search in command names
			if (key = command)
				return key

			; * Search in command aliases
			for akey, avalue in value.aliases {
				if (command = avalue)
					return key
			}
		}
	}

	save() {
		for key, value in this.guilds {
			value.save()
		}
	}

	callCommand(what, name, args*) {
		fn := this.commands[name][what]
		return %fn%(this.commands[name], args*)
	}

	E_ready(data) {
		this.loadGuilds()
		for key, value in this.commands
			this.callCommand("ready", key)

		this.api.SetPresence("online", "Discord.ahk")
	}

	E_MESSAGE_CREATE(ctx) {
		static bot_what := ["bot_question", "bot_what", "bot_angry"]
		if (ctx.author.bot)
			return

		prefix := this.guilds[ctx.data.guild_id].data.prefix
		isPing := (SubStr(ctx.message, 1, StrLen(this.bot.USER_ID)+4) == "<@!" this.bot.USER_ID ">")
		if (SubStr(ctx.message,1,1) == prefix || isPing) {
			data := StrSplit(SubStr(ctx.message, 2), " ",, 2+isPing)
			if isPing
				data.RemoveAt(1)
			command := this.getAlias(data[1])

			if !command && isPing
				command = help

			if !command
				return ctx.react(bot_what[random(1,3)])

			try {
				debug.print(ctx.author.name " issued command " ctx.message " on " ctx.guild.name)
				this.callCommand("called", command, ctx, StrSplit(data[2], " "))
			} catch e {
				return this.printError(ctx, e)
			}
		}
	}

	printError(ctx, e) {
		http := new requests("POST", this.bot.ERROR_WEBHOOK)
		http.headers["Content-Type"] := "application/json"
		embed := new discord.embed()
		embed.setEmbed("Error on command", ctx.message, 0xFF5959)
		embed.addField("On Guild", ctx.guild.name " (" ctx.author.id ")")
		embed.addField("Issued by", ctx.author.name " (" ctx.author.id ")")
		embed.addField("Message", e.message)
		embed.addField("What", e.what)
		embed.addField("Extra", e.extra)
		embed.addField("File", "``" e.file "`` (" e.line ")")
		data := JSON.dump(embed.get(true))
		http.send(data)
	}
}

class command_ {
	__New(bot) {
		this.bot := bot
		this.cooldowns := {}
	}

	called(ctx, args*) {
		author := ctx.author.id
		if this.cooldown {
			if (this.cooldowns[author])
				return ctx.react("bot_cooldown")

			this.cooldowns[author] := true
			fn := ObjBindMethod(this, "removeCooldown", author)
			SetTimer %fn%, % this.cooldown * 1000
		}

		if (this.owneronly && this.bot.bot.OWNER_ID != author)
			return ctx.react("bot_notallowed")

		if (this.serverowneronly && ctx.author.id != ctx.guild.owner)
			return ctx.react("bot_notallowed")

		this.call(ctx, args*)
	}

	removeCooldown(author) {
		this.cooldowns[author] := false
	}
}

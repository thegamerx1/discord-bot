
class DiscoBot {
	init() {
		this.guilds := {}
		this.commands := {}
		this.loadCommands()
		this.cache := {guild:{}, user:{}}
		botFile := new configLoader("settings.json")
		this.bot := botFile.data
		this.api := new Discord(this, this.bot.TOKEN, 769)
		if (A_Args[1] == "-reload") {
			this.resumedata := StrSplit(A_Args[2], ",", " ")
			this.api.setResume(this.resumedata[1], this.resumedata[2])
		}
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

	save() {
		for key, value in this.guilds {
			value.save()
		}
	}

	callCommand(what, name, args*) {
		fn := this.commands[name][what]
		return %fn%(this.commands[name], args*)
	}

	E_ready() {
		this.loadGuilds()
		for key, value in this.commands
			this.callCommand("ready", key)

		this.api.SetPresence("online", "Discord.ahk")
	}

	E_MESSAGE_CREATE(ctx) {
		message := ctx.data.content
		if (ctx.author.bot)
			return

		if (SubStr(message, 1,1) == this.guilds[ctx.data.guild_id].data.prefix) {
			command := StrSplit(SubStr(message, 2), " ", , 2)
			if !this.commands[command[1]]
				return ctx.react("❓")

			if (this.callCommand("check", command[1], ctx)) {
				debug.print(ctx.author.username " issued command " message " on " ctx.data.guild)
				this.callCommand("call", command[1], ctx, command[2])
			}
		}
	}

	E_GUILD_CREATE(data) {
		this.cache[data.id] := data
	}
}

class command_ {
	__New(bot) {
		this.bot := bot
		this.cooldowns := {}
	}

	check(ctx) {
		author := ctx.author.id
		if this.cooldown {
			if (this.cooldowns[author])
				return ctx.react("🕒")

			this.cooldowns[author] := true
			fn := ObjBindMethod(this, "removeCooldown", author)
			SetTimer %fn%, % this.cooldown * 1000
		}

		if (this.owneronly && this.bot.bot.OWNER_ID != author)
			return ctx.react("⛔")

		; if (this.serverowneronly && ctx.author.id != )

		return 1
	}

	removeCooldown(author) {
		this.cooldowns[author] := false
	}
}
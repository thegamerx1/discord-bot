
class DiscoBot {
	init() {
		this.guilds := {}
		this.commands := {}
		this.loadCommands()
		this.botFile := new configLoader("settings.json")
		this.bot := this.botFile.data
		this.api := new Discord(this, this.bot.TOKEN, 769)
		OnExit(ObjBindMethod(this, "save"))
	}

	loadCommands() {
		debug.print("Loading commands")
		for key, value in includer.list {
			command := "Command_" value
			this.commands[value] := new Command_%value%
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
		; this.botFile.save()
		for key, value in this.guilds {
			value.save()
		}
	}

	E_ready() {
		this.loadGuilds()
		this.api.SetPresence("online", "Discord.ahk")
	}

	E_MESSAGE_CREATE(data) {
		message := data.content
		if (data.author.id == this.bot.USER_ID)
			return

		if (SubStr(message, 1,1) == this.guilds[data.guild_id].data.prefix) {
			command := StrSplit(SubStr(message, 2), " ", , 2)
			if !this.commands[command[1]] {
				; TODO: react with question
				return
			}
			debug.print(data.author.username "issued command " message " on " data.guild_id) ; TODO: Guild name
			fn := this.commands[command[1]]
			%fn%(this, data, command[2])
		}
	}

	E_GUILD_CREATE(data) {
		this.loadGuild(data.id)
	}
}
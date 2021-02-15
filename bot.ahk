class DiscoBot {
	init() {
		this.guilds := this.commands := this.cache := {}
		botFile := new configLoader("settings.json")
		this.bot := botFile.data
		this.settings := new configLoader("global.json")
		if this.bot.release
			debug.attachFile := "log.log"

		this.loadCommands()
		this.api := new Discord(this, this.bot.TOKEN, this.bot.INTENTS, this.bot.OWNER_GUILD_ID)
		if (A_Args[1] == "-reload")
			this.resume := StrSplit(A_Args[2], ",", " ")

		OnExit(ObjBindMethod(this, "save"))
	}

	_event(event, data) {
		fn := this["E_" event]
		capture := false
		for key, value in this.commands
			if this.executeCommand(key, "_event", event, data)
				capture := true
		if !fn
			debug.print(">Event not handled " event)

		if !capture
			%fn%(this, data)
	}

	loadCommands() {
		debug.print(">Loading commands")
		for _, value in includer.list {
			command := "Command_" value
			this.commands[value] := new Command_%value%(this)
		}
		for name in this.commands {
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
	}

	E_GUILD_CREATE(data) {
		this.guilds[data.id] := new configLoader("guildData/" data.id ".json", {prefix: this.bot.PREFIX})
	}

	E_GUILD_DELETE(data) {
		if data.unavailable
			return
		this.guilds[data.id] := ""
		FileDelete % "guildData/" data.id ".json"
	}


	getAlias(name) {
		return this.cache.aliases[name]
	}

	save() {
		for key, value in this.guilds {
			value.save()
		}
		this.settings.save()
	}

	executeCommand(command, func, args*) {
		fn := this.commands[command][func]
		return %fn%(this.commands[command], args*)
	}

	E_ready(args*) {
		this.api.SetPresence("online", "Selling your data")
		this.resume := ""
	}

	E_MESSAGE_CREATE(ctx) {
		static bot_what := ["bot_question", "bot_what", "bot_angry"]
		if ctx.author.bot
			return

		prefix := this.guilds[ctx.guild.id].data.prefix
		isPing := StartsWith(ctx.message, "<@!" this.api.self.id ">")
		if (isPing || StartsWith(ctx.message, prefix)) {
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
				embed := new discord.embed("Oops!", "An error ocurred on the command and my developer has been notified.`n`nYou can you join the support server [here](" this.bot.SUPPORT_SERVER ")!", 0xAC3939)
				embed.setFooter("Error ID: " e.errorid)
				ctx.reply(embed)
				this.printError(ctx, e)
			}
		}
	}

	printError(ctx, e) {
		static source := "**{}:** {} ({})"
		static source1 := "**{}:** {}"
		embed := new discord.embed("Error on command", ctx.message, 0xFF5959)
		embed.addField("Source", format(source, "Guild", ctx.guild.name, ctx.guild.id) "`n" format(source, "User", ctx.author.mention, ctx.author.id))
		embed.addField("Error", format(source1, "Message", e.message) "`n" format(source1, "What", e.what) "`n" format(source1, "Extra", e.extra))
		embed.addField("File", "``" e.file "`` (" e.line ")")
		embed.addField("Error ID", "`" e.errorid "`")
		discord.utils.sendWebhook(embed, this.bot.ERROR_WEBHOOK)
	}

	class command {
		__New(bot) {
			if !this.permissions
				this.permissions := []
			this.permissions.push("ADD_REACTIONS")
			this.bot := bot
			this.cooldowns := {}
		}

		_event(event, data) {
			fn := this["E_" event]
			return %fn%(this, data)
		}

		_parseArgs(byref args, byref cmdargs) {
			static regex := "[^\s""']+|""([^""]+)"""
			out := []
			while match := regex(args, regex) {
				if (A_Index >= this.args.length()) {
					out.push(args)
					break
				}
				args := StrReplace(args, match.value,,, 1)
				out.push(match[1] ? match[1] : match[0])
			}
			args := out

			for _, cmd in this.commands {
				if StartsWith(args[1], cmd.name) {
					cmdargs := cmd.args
					cmdspace := cmd.name " "
					if StartsWith(args[1], cmdspace) {
						args[1] := temp := SubStr(args[1], StrLen(cmdspace)+1)
					} else {
						temp := args.RemoveAt(1)
					}
					return cmd.name
				}
			}
			return
		}

		called(ctx, command, args := "") {
			author := ctx.author.id
			if !contains("SEND_MESSAGES", ctx.self.permissions)
				return

			if !contains("EMBED_LINKS", ctx.self.permissions) {
				ctx.reply("I need ``EMBED_LINKS`` to function!")
				return
			}

			neededperms := ""
			for _, value in this.permissions {
				if !contains(value, ctx.self.permissions) {
					neededperms .= Chr(8226) " " value "`n"
				}
			}

			for _, value in this.userperms {
				if !contains(value, ctx.author.permissions) {
					ctx.reply(new discord.embed(, "You don't have permissions to do that!"))
					return
				}
			}

			if neededperms {
				embed := new discord.embed("I need the following permissions for that", neededperms)
				ctx.reply(embed)
				return
			}

			if (this.owneronly && this.bot.bot.OWNER_ID != author)
				return ctx.react("bot_notallowed")

			cmdargs := this.args
			func := this._parseArgs(args, cmdargs)

			for _, arg in cmdargs {
				if (args[1] = "") {
					if (arg.optional && arg.default != "")
						args[i] := arg.default

					if !arg.optional {
						this.bot.executeCommand("help", "call", ctx, [command], "Argument missing: " arg.name, cmdargs, func)
						return
					}
				} else if (arg.type && arg.type != typeof(args[1])) {
					this.bot.executeCommand("help", "call", ctx, [command], "Argument ``" arg.name "`` requires type ``" arg.type "``" , cmdargs, func)
					return
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

			try {
				this[func ? "C_" func : "call"](ctx, args)
			} catch e {
				if (e = -99)
					return
				if !IsObject(e)
					e := Exception(e, "Not specified")

				e.errorid := RandomString(52)
				throw e
			}
		}

		except(ctx, message) {
			ctx.reply(new discord.embed(, ctx.getEmoji("bot_no") " " message, 0xAC3939))
			throw -99
		}

		setCooldown(author, time := "") {
			if !time
				time := this.cooldown
			this.cooldowns[author] := {time: A_TickCount + time * 1000, reacted: false}
		}
	}
}
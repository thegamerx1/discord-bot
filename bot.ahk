class DiscoBot {
	init() {
		this.guilds := this.commands := this.cache := {}
		this.bot := new configLoader("settings.json").data
		this.settings := new configLoader("global.json")
		if this.bot.release
			debug.attachFile := "log.log"

		this.loadCommands()
		if (A_Args[1] = "-reload")
			this.resume := StrSplit(A_Args[2], ",")
 		this.api := new Discord(this, this.bot.token, this.bot.intents, this.bot.owner.guild, this.bot.owner.id)
		OnExit(ObjBindMethod(this, "save"))
	}

	_event(event, data) {
		fn := this["E_" event]
		capture := false
		for key, value in this.commands
			if this.executeCommand(key, "_event", event, data)
				capture := true
		; if !fn
		; 	debug.print("|Event not handled " event)

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
		this.guilds[data.id] := new configLoader("guildData/" data.id ".json", {prefix: this.bot.prefix})
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
		this.api.SetPresence("online", "@me for prefix")
		this.resume := ""
	}

	printError(ctx, e) {
		static source := "**{}:** {} ({})"
		static source1 := "**{}:** {}"
		embed := new discord.embed("Exception", discord.utils.codeblock("js", ctx.message), 0xFF5959)
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
		static bot_what := ["question", "what", "angry", Unicode.get("question"), "blobpeek", "confuseddog"]
		static pingPrefix := "My prefix is ``{1}```n***{1}help*** for help menu!`n***{1}help*** **<command>** for command description!"
		if ctx.author.bot
			return

		ctx.prefix := this.guilds[ctx.guild.id].data.prefix
		isPing := StartsWith(ctx.message, "<@!" this.api.self.id ">")
		if (isPing || StartsWith(ctx.message, ctx.prefix)) {
			data := StrSplit(SubStr(ctx.message, StrLen(ctx.prefix)+1), [" ", "`n"],, 2+isPing)

			if isPing
				data.RemoveAt(1)

			command := this.getAlias(data[1])

			if (!command && isPing)
				return ctx.reply(new discord.embed(, format(pingPrefix, ctx.prefix)))

			if (!command && contains("ADD_REACTIONS", ctx.self.permissions))
				return ctx.react(random(bot_what))


			try {
				this.executeCommand(command, "called", ctx, command, data[2])
			} catch e {
				embed := new discord.embed("Oops!", "An error ocurred on the command and my developer has been notified.`n`nYou can you join the support server [here](" this.bot.owner.server_invite ")!", 0xAC3939)
				embed.setFooter("Error ID: " e.errorid)
				ctx.reply(embed)
				this.printError(ctx, e)
			}
		}
	}

	class command {
		cooldownper := 10
		category := "Other"
		cooldown := 1
		info := "Does the unkown"

		__New(byref bot) {
			if !this.permissions
				this.permissions := []
			if this.owneronly
				this.cooldown := 0
			this.permissions.push("ADD_REACTIONS")
			this.bot := bot
			this.SET := bot.bot
			this.cooldowns := {}
		}

		_event(event, data) {
			fn := this["E_" event]
			return %fn%(this, data)
		}

		_parseArgs(byref args, byref cmdargs) {
			static regex := "[^\s""']+|""([^""]+)"""
			name := ""
			for _, cmd in this.commands {
				if StartsWith(args, cmd.name) {
					cmdargs := cmd.args
					cmdspace := cmd.name " "
					if StartsWith(args, cmdspace) {
						args := temp := SubStr(args, StrLen(cmdspace)+1)
					} else {
						temp := args.RemoveAt(1)
					}
					name := cmd.name
				}
			}
			out := []
			while match := regex(args, regex) {
				if (A_Index >= cmdargs.length()) {
					out.push(args)
					break
				}
				args := StrReplace(args, match.0 " ",,, 1)
				out.push(match.1 ? match.1 : match.0)
			}
			args := out
			return name
		}

		called(ctx, command, args := "") {
			author := ctx.author
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
				if !contains(value, author.permissions) {
					ctx.reply(new discord.embed(, "You don't have permissions to do that!"))
					return
				}
			}

			if neededperms {
				embed := new discord.embed("I need the following permissions for that", neededperms)
				ctx.reply(embed)
				return
			}

			if (this.owneronly && !author.isBotOwner)
				return ctx.react("police")

			cmdargs := this.args
			func := this._parseArgs(args, cmdargs)


			; TODO: subcommand aliase
			for _, arg in cmdargs {
				if (args[1] = "") {
					if (arg.optional && arg.default != "")
						args[A_Index] := arg.default

					if !arg.optional {
						this.bot.executeCommand("help", "call", ctx, [command], "Argument missing: " arg.name, cmdargs, func)
						return
					}
				} else if (arg.type && arg.type != typeof(args[1])) {
					this.bot.executeCommand("help", "call", ctx, [command], "Argument ``" arg.name "`` requires type ``" arg.type "``" , cmdargs, func)
					return
				}
			}
			if (this.cooldown && !(author.isBotOwner && this.bot.settings.data.dev)) {
				cooldown := this.getCooldown(author.id)
				cool := cooldown.get()
				if cool.cooldown {
					if !cooldown.reacted {
						cooldown.reacted := true
						this.onCooldown(ctx, author, cool.wait)
					}
					return
				}
				cooldown.add()
			}

			try {
				this[func ? "C_" func : "call"](ctx, args)
			} catch e {
				if (e = -99)
					return
				if !IsObject(e)
					e := Exception(e, "Not specified")

				e.errorid := SHA1(ctx.message.timestamp)
				throw e
			}
		}


		onCooldown(ctx, author, time) {
			ctx.reply(new discord.embed("You are on cooldown!", ctx.getEmoji("cooldown") " Wait for " time "s"))
		}

		except(ctx, message) {
			ctx.reply(new discord.embed(, ctx.getEmoji("no") " " message, 0xAC3939))
			throw -99
		}

		setCooldown(user, time := "") {
			if !time
				time := this.cooldown
			this.cooldowns[user] := {time: A_TickCount + time * 1000, reacted: false}
		}

		getCooldown(byref user) {
			if !this.cooldowns[user]
				this.cooldowns[user] := new DiscoBot.cooldown(user, this.cooldown, this.cooldownper)
			return this.cooldowns[user]
		}
	}


	Class cooldown {
		__New(userid, cooldown, per) {
			this.user := userid
			this.cooldown := cooldown
			this.per := per
			this.list := []
		}

		get() {
			total := wait := 0
			for _, count in this.list {
				if (count < A_TickCount) {
					this.reacted := false
					this.list.RemoveAt(A_Index)
					continue
				}
				wait += count-A_TickCount
				total += this.per/this.cooldown
			}
			debug.print("[Cooldown] " total "/" this.per " " wait "ms")
			return {cooldown: total >= this.per, wait: Round(wait/1000,2)}
		}

		add() {
			this.list.push(A_TickCount+this.per/this.cooldown*1000+500)
		}
	}
}
class DiscoBase {
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
			temp := StrSplit(args, " ")
			for _, cmd in this.commands {
				if (temp[1] = cmd.name) {
					cmdargs := cmd.args
					args := SubStr(args, StrLen(cmd.name)+(StartsWith(args, cmd.name " ") ? 2 : 1))
					name := cmd.name
					break
				}
			}
			out := []
			while match := regex(args, regex) {
				if (A_Index >= cmdargs.length()) {
					out.push(args)
					break
				}

				args := RegExReplace(args, match.0 "\s*",,, 1)
				out.push(match.1 ? match.1 : match.0)
			}
			args := out
			return name
		}

		called(ctx, command, args := "") {
			author := ctx.author
			if (this.owneronly && !author.isBotOwner)
				return

			if (!ctx.isInteraction && !contains("SEND_MESSAGES", ctx.self.permissions))
				return

			if (!ctx.isInteraction && !contains("EMBED_LINKS", ctx.self.permissions)) {
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
					ctx.reply(new discord.embed(, "You don't have permissions to do that!", "error"))
					return
				}
			}

			if neededperms {
				embed := new discord.embed("I need the following permissions for that", neededperms, "error")
				ctx.reply(embed)
				return
			}

			cmdargs := this.args
			func := this._parseArgs(args, cmdargs)


			; TODO: subcommand aliases
			for _, arg in cmdargs {
				if (args[A_Index] = "") {
					if (arg.optional && arg.default != "")
						args[A_Index] := arg.default

					if !arg.optional {
						this.bot.executeCommand("help", "call", ctx, [command], "Argument missing: " arg.name, cmdargs, func)
						return
					}
				} else if (arg.type && !contains(arg.type, typeof(args[A_Index])) && !arg.optional) {
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

				e.errorid := SHA1(ctx.timestamp)
				throw e
			}
		}


		onCooldown(ctx, author, time) {
			embed := new discord.embed("You are on cooldown!", ctx.getEmoji("cooldown") " Wait for " time "s")
			embed.setFooter("Commands will be ignored until cooldown is released")
			ctx.reply(embed)
		}

		except(ctx, message) {
			ctx.reply(new discord.embed(, ctx.getEmoji("no") " " message, "error"))
			throw -99
		}

		setCooldown(user, time := "") {
			if !time
				time := this.cooldown
			this.cooldowns[user] := {time: A_TickCount + time * 1000, reacted: false}
		}

		getCooldown(byref user) {
			if !this.cooldowns[user]
				this.cooldowns[user] := new DiscoBase.cooldown(user, this.cooldown, this.cooldownper)
			return this.cooldowns[user]
		}
	}


	class cooldown {
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

			; debug.print("[Cooldown] " total "/" this.per " " wait "ms")
			return {cooldown: total >= this.per, wait: Round(wait/1000,2)}
		}

		add() {
			this.list.push(A_TickCount+this.per/this.cooldown*1000+500)
		}

		reset() {
			this.list := []
		}
	}
}
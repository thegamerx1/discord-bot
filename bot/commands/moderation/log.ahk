class command_log extends DiscoBase.command {
	cooldown := 3
	info := "Manages the logging system"
	infolong := "Available types: ``joins`` and ``edits``"
	permissions := ["MANAGE_MESSAGES"]
	userperms := ["ADMINISTRATOR"]
	commands := [{name: "set", args: [{name: "type"}, {name: "channel", optional: true}]}]

	static types := ["joins", "edits"]


	E_GUILD_MEMBER_REMOVE(data) {
		this.manageJoin(data, 0)
	}

	E_GUILD_MEMBER_ADD(data) {
		this.manageJoin(data, 1)
	}

	E_MESSAGE_UPDATE(data) {
		this.messageEdit(data, 0)
	}

	E_MESSAGE_DELETE(data) {
		this.messageEdit(data, 1)
	}

	E_MESSAGE_DELETE_BULK(ctx) {
		data := this.bot.getGuild(ctx.guild.id)
		if !(data.logging.edits || ctx.author.bot)
			return

		channel := ctx.guild.getChannel(data.logging.edits)

		if channel.canI(["SEND_MESSAGES", "EMBED_LINKS"]) {
			embed := new discord.embed("Message bulk delete", "Messages deleted: ``" ctx.count "```nIn Channel: " ctx.channel.mention)
			channel.send(embed)
		}
	}

	messageEdit(ctx, isDelet) {
		data := this.bot.getGuild(ctx.guild.id)
		if !(data.logging.edits || ctx.author.bot)
			return

		channel := ctx.guild.getChannel(data.logging.edits)

		if channel.canI(["SEND_MESSAGES", "EMBED_LINKS"]) {
			embed := new discord.embed("Message " (isDelet ? "deleted" : "edited"),, isDelet ? "error" : "blue")
			embed.setThumbnail(ctx.author.avatar)
			embed.addField("User", ctx.author.mention "`n" ctx.author.notMention " (" ctx.author.id ")")
			if !isDelet {
				embed.addField("Old message", ctx.edits[1] ? discord.utils.codeblock("text",ctx.edits[1].content) : "Not logged")
				embed.setDescription("[Jump to message](" ctx.link ")")
			}

			embed.addField(isDelet ? "Message" : "New message", discord.utils.codeblock("text", ctx.content))
			attach := []
			for _, att in ctx.attachments {
				attach.push("[" att.content_type "](" att.url ")")
			}
			embed.addField("Attachments", Array2String(attach))
			channel.send(embed)
		}
	}

	manageJoin(ctx, isJoin) {
		guild := this.bot.getGuild(ctx.guild.id)
		if !guild.logging.joins
			return
		channel := ctx.guild.getChannel(guild.logging.joins)
		if channel.canI(["SEND_MESSAGES", "EMBED_LINKS"]) {
			embed := new discord.embed("Member " (isJoin ? "join" : "leave"))
			embed.setThumbnail(ctx.user.avatar)
			embed.addField("User", ctx.user.notMention " (" ctx.user.id ")")
			if !isJoin {
				roles := []
				for _, role in ctx.user.roles {
					roles.push(ctx.guild.getRole(role).name)
				}
				embed.addField("Roles", Array2String(roles, ", ", "``"))
				; embed.addField("Joined in", Miss2Text(discord.utils.ISODATE(ctx.user.joined_at, true)))
			}
			embed.addField("Account created at", Miss2Text(discord.utils.snowflakeTime(ctx.user.id) "UTC"))
			channel.send(embed)
		}
	}

	c_set(ctx, args) {
		static successSet := "{} ``{}`` set to {}"
		if !(type := this.types[contains(args[1], this.types)])
			this.except(ctx, "Type must be one of " Array2String(this.types, ", ", "``") "!")

		channel := ctx.guild.findChannel(args[2])
		if !channel
			this.except(ctx, "Couldn't find channel with that id/name :(")
		loggy := ctx.guild.data.logging
		if !args[2] {
			if !loggy[args[1]]
				this.except(ctx, type " is already unset!")

			loggy[args[1]] := ""
			ctx.reply(new discord.embed(, ctx.getEmoji(this.bot.randomCheck()) type " disabled"))
			return
		}

		if (loggy[args[1]] = channel)
			this.except(ctx, type " is already set to that channel!")

		loggy[args[1]] := channel
		ctx.reply(new discord.embed(, format(successSet, ctx.getEmoji(this.bot.randomCheck()), type, ctx.guild.getChannel(channel).mention)))
	}

	call(ctx, args) {
		embed := new discord.embed("Logging status")
		embed.addField("Message edits/deletes: ``" this.types[2] "``", ifNull(ctx.guild.getChannel(ctx.guild.data.logging.edits).name, "Not set"))
		embed.addField("User join/leaves: ``" this.types[1] "``", ifNull(ctx.guild.getChannel(ctx.guild.data.logging.joins).name, "Not set"))
		ctx.reply(embed)
	}
}
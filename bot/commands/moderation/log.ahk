class command_log extends DiscoBase.command {
	cooldown := 3
	info := "Manages the logging system"
	infolong := "Configure logging via the dashboard"
	userperms := ["ADMINISTRATOR"]
	aliases := ["logging"]

	static types := ["joins", "edits", "deletes"]


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
		if !(channel := this.continuee(ctx, "deletes"))
			return

		embed := new discord.embed("Message bulk delete", "Messages deleted: ``" ctx.count "```nIn Channel: " ctx.channel.mention)
		try {
			channel.send(embed)
		} catch e {
			debug.print(e)
		}
	}

	messageEdit(ctx, isDelet) {
		if !(channel := this.continuee(ctx, isDelet ? "deletes" : "edits"))
			return

		embed := new discord.embed("Message " (isDelet ? "deleted" : "edited"),, isDelet ? "error" : "blue")
		embed.setThumbnail(ctx.author.avatar)
		embed.addField("Info", ctx.author.mention " "ctx.channel.mention "`n" ctx.author.notMention " (" ctx.author.id ")")
		if !isDelet {
			embed.addField("Old message", ctx.edits[1] ? Truncate(discord.utils.codeblock("text", ctx.edits[1].content), 999) : "Not logged")
			embed.setDescription("[Jump to message](" ctx.link ")")
		}

		embed.addField(isDelet ? "Message" : "New message", Truncate(discord.utils.codeblock("text", ctx.content), 999))
		attach := []
		for _, att in ctx.attachments {
			attach.push("[" att.content_type "](" att.url ")")
		}
		embed.addField("Attachments", Array2String(attach))
		try {
			channel.send(embed)
		} catch e {
			debug.print(e)
		}
	}

	manageJoin(ctx, isJoin) {
		if !(channel := this.continuee(ctx, "edits"))
			return

		embed := new discord.embed("Member " (isJoin ? "join" : "leave"))
		embed.setThumbnail(ctx.user.avatar)
		embed.addField("User", ctx.user.notMention " (" ctx.user.id ")")
		if !isJoin {
			roles := []
			for _, role in ctx.user.roles {
				roles.push(ctx.guild.getRole(role).name)
			}
			embed.addField("Roles", Array2String(roles, ", ", "``"))
		}
		embed.addField("Account created at", Miss2Text(discord.utils.snowflakeTime(ctx.user.id) "UTC"))
		try {
			channel.send(embed)
		} catch e {
			debug.print(e)
		}
	}

	continuee(ctx, type) {
		data := this.bot.getGuild(ctx.guild.id)
		if (!data.logging[type] || ctx.author.bot)
			return

		channel := ctx.guild.getChannel(data.logging[type])
		if channel.canI(["SEND_MESSAGES", "EMBED_LINKS"]) {
			return channel
		} else {
			data.logging[type] := 0
		}
	}

	call(ctx, args) {
		embed := new discord.embed("Logging status", "Configure logging via the dashboard")
		for key, value in this.types
			embed.addField(value, ifNull(ctx.guild.getChannel(ctx.guild.data.logging[value]).mention, "Not set"), true)
		ctx.reply(embed)
	}
}
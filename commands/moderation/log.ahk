class command_log extends DiscoBase.command {
	cooldown := 3
	disabled := true
	info := "Manages the logging system"
	infolong := "Available types: ``join`` and ``user``"
	permissions := ["MANAGE_MESSAGES"]
	userperms := ["ADMINISTRATOR"]
	commands := [{name: "set", args: [{name: "type"}, {name: "channel", optional: true}]}]

	static types := ["join", "user"]


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

	messageEdit(ctx, isDelet) {

	}

	manageJoin(ctx, isJoin) {
		guild := this.bot.getGuild(ctx.guild.id)
		if !guild.logging.join
			return
		channel := ctx.guild.getChannel(guild.logging.join)
		if !channel.canI(["SEND_MESSAGES", "EMBED_LINKS"])
			return

		embed := new discord.embed("Member " (isJoin ? "join" : "leave"))
		embed.setThumbnail(ctx.user.avatar)
		embed.addField("User", ctx.user.notMention " (" ctx.user.id ")")
		if !isJoin {
			roles := []
			for _, role in ctx.user.roles {
				roles.push(ctx.guild.getRole(role).name)
			}
		}
		embed.addField("Roles", Array2String(roles, ", ", "``"))
		channel.send(embed)
	}

	c_set(ctx, args) {
		static successSet := "{} {} set to ``{}``"
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
		ctx.reply(new discord.embed(, format(successSet, ctx.getEmoji(this.bot.randomCheck()), type, ctx.guild.getChannel(channel).name)))
	}

	call(ctx, args) {
		embed := new discord.embed("Logging status")
		embed.addField("Message edits/deletes", ifNull(ctx.guild.data.logging.edits, "Not set"))
		embed.addField("User join/leaves", ifNull(ctx.guild.data.logging.joins, "Not set"))
		ctx.reply(embed)
	}
}
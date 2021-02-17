class command_suggestion extends DiscoBot.command {
	cooldown := 2
	cooldownper := 60*2
	permissions := ["MANAGE_MESSAGES"]
	info := "Make a suggestion/bug report"
	aliases := ["suggest", "feature", "bug"]
	args := [{optional: false, name: "request"}]
	category := "Bot"

	call(ctx, args) {
		static source := "**{}:** {} ({})"
		if !(this.SET.release || !this.bot.settings.data.dev)
			this.except(ctx, "Only enabled on release!")
		id := SHA1(ctx.message.timestamp)
		body := format(source, "Guild", ctx.guild.name, ctx.guild.id) "`n" format(source, "User", ctx.author.mention, ctx.author.id)
		embed := new discord.embed("Suggestion", body discord.utils.codeblock("text", args[1]))
		embed.setFooter("Suggestion ID: " id)
		discord.utils.webhook(embed, this.SET.webhooks.suggest)
		response := new discord.embed("Thank you", ctx.author.mention " your suggestion has been sent")
		response.setFooter("Suggestion ID: " id)
		ctx.delete()
		ctx.reply(response)
	}
}
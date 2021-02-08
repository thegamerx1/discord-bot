class command_about extends command_ {
	static cooldown := 5
	, info := "Gets bot info"

	start() {
		this.pid := DllCall("GetCurrentProcessId")
	}

	call(ctx, args) {
		embed := new discord.embed("Bot information")
		embed.setFooter("Made by " ctx.author.get(this.bot.bot.OWNER_ID).notMention())
		embed.addField("Ram usage", ctx.GetEmoji("bot_ram") GetProcessMemoryUsage(this.pid) "MiB")
		embed.addField("Guilds", this.bot.api.cache.guild.Count())
		ctx.reply(embed)
	}
}
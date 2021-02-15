#Include <Process>
class command_about extends DiscoBot.command {
	static cooldown := 5
	, info := "Gets bot info"
	, category := "Bot"

	start() {
		this.pid := DllCall("GetCurrentProcessId")
		this.uptime := new Counter(, true)
	}

	call(ctx, args) {
		embed := new discord.embed("About")
		embed.setFooter("Made by " ctx.author.get(this.bot.bot.OWNER_ID).notMention() " " Chr(8226) " https://github.com/thegamerx1/discord-bot")
		data := [{name: "Bot", content: [{name:"Uptime"
				,value: niceDate(this.uptime.get())}
				,{name: "Guilds", value: this.bot.api.cache.guild.Count()}
				,{name: "Ram Usage", value: GetProcessMemoryUsage(this.pid) "MiB"}]}
			,{name: "System", content: [{name:"Uptime", value:  niceDate(A_TickCount)}]}]
		for _, value in data {
			out := ""
			for _, ef in value.content {
				out .= "``" ef.name "`` " ef.value "`n"
			}
			embed.addField(value.name, out, true)

		}
		ctx.reply(embed)
	}
}
class command_server extends DiscoBot.command {
	static  cooldown := 2
	, info := "Gets info about the server"
	, category := "Fun"


	call(ctx, args) {
		ctx.typing()
		embed := new discord.embed(ctx.guild.name, "**ID**: " ctx.guild.id)
		embed.addField("Owner", ctx.author.get(ctx.guild.owner).mention, true)
		embed.addField("Region", ctx.guild.data.region, true)
		channels := {voice:0,text:0,no:0}
		for _, value in ctx.guild.data.channels {
			switch value.type {
				case 0:
					channels.text++
				case 2:
					channels.voice++
				default:
					channels.no++
			}
		}
		embed.addField("Channels", ctx.getEmoji("text_channel") channels.text "`n" ctx.getEmoji("voice_channel") channels.voice "`n" ctx.getEmoji("bot_duckwhat") channels.no, true)
		fet := ""
		for _, value in ctx.guild.data.features {
			fet .= Chr(8226) " " format("{:T}", StrReplace(value, "_", " ")) "`n"
		}
		embed.addField("Features", fet)
		embed.setFooter("Created " Chr(8226) " " ctx.guild.data.joined_at)
		ctx.reply(embed)
	}
}
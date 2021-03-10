class command_server extends DiscoBase.command {
	cooldown := 3
	info := "Gets info about the server"

	call(ctx, args) {
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
		embed.addField("Channels", ctx.getEmoji("text_channel") channels.text "`n" ctx.getEmoji("voice_channel") channels.voice "`n" ctx.getEmoji("duckwhat") channels.no, true)
		fet := ""
		for _, value in ctx.guild.data.features {
			fet .= Chr(8226) " " format("{:T}", StrReplace(value, "_", " ")) "`n"
		}
		embed.addField("Features", fet)
		embed.setFooter("Created " Chr(8226) " " ctx.guild.data.joined_at)
		ctx.reply(embed)
	}
}
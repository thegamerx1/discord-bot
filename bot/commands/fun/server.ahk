class command_server extends DiscoBase.command {
	cooldown := 3
	info := "Gets info about the server"

	call(ctx, args) {
		embed := new discord.embed(ctx.guild.name, "**ID**: " ctx.guild.id)
		embed.addField("Owner", ctx.author.get(ctx.guild.owner_id).mention, true)
		embed.addField("Region", ctx.guild.region, true)
		channels := {voice:0,text:0,no:0}
		for _, value in ctx.guild.channels {
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
		for _, value in ctx.guild.features {
			fet .= Chr(8226) " " title(StrReplace(value, "_", " ")) "`n"
		}

		prescen := {}
		for _, mem in ctx.guild.presences {
			if !prescen[mem.status]
				prescen[mem.status] := 0
			prescen[mem.status]++
		}
		prescen["offline"] := ctx.guild.members.length() - ctx.guild.presences.length()
		presences := ""
		for status, count in prescen {
			presences .= ctx.getEmoji(status) " " count
		}
		embed.addField("Features", fet)
		embed.addField("Users", presences)
		embed.setFooter("Created")
		embed.setTimestamp(ctx.guild.created_at)
		ctx.reply(embed)
	}
}
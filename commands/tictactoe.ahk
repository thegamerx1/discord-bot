class command_tictactoe extends DiscoBot.command {
	cooldown := 1
	cooldownper := 4
	disabled := true
	info := "Play tic tac toe against the bot!"
	category := "Fun"
	aliases := ["ttt"]
	commands := [{name: "end"}]

	start() {
		this.play := {}
	}

	c_end(ctx) {
		play := this.play[ctx.author.id]
		if play {
			this.play.Delete(ctx.author.id)
			ctx.reply(new discord.embed("You surrender and your oponent wins!"))
		}
	}

	call(ctx, args) {
		if this.play[ctx.author.id]
			this.except(ctx, "You are already in a game!")


		msg := ctx.reply("Generating game..")
		table := [2, 2, 2, 2, 2, 2, 2, 2, 2]
		this.play[ctx.author.id] := {now: random(), table: table, player: random(), msg: msg, ctx: ctx}
		msg.edit(this.generateEmbed(msg, ctx.author.id))
	}

	E_MESSAGE_CREATE(ctx) {
		play := this.play[ctx.author.id]
		msg := play.msg
		if (ctx.channel.id != msg.channel.id)
			return

		try {
			this.makeMove(play, play.player, ctx.message)
		} catch {
			return
		}
		msg.edit(this.generateEmbed(msg, ctx.author.id))
		if (play.winner != "")
			this.play.Delete(ctx.author.id)
	}

	generateEmbed(ctx, id) {
		static icons := [Unicode.get("x"), Unicode.get("o")]
		static iconsascii := ["x", "o"]
		static pformat := ":{}: {}`n"
		static wformat := "**Winner is:** :{}:"
		play := this.play[id]
		body := format(pformat, iconsascii[play.player+1], play.ctx.author.mention) format(pformat, iconsascii[!play.player+1], "Computer")
		if (play.winner != "")
			body .= format(wformat, iconsascii[play.winner+1])
		embed := new discord.embed("Tic Tac Toe",  body)
		if play.now
			this.makeMove(play, !play.player)

		table := ""
		for _, box in play.table {
			table .= " | " (box = 2 ? A_Index : icons[box+1])
			if !Mod(A_Index, 3)
				table .= " |`n"
		}

		embed.addField("Table", discord.utils.codeblock("text", table))
		return embed
	}

	makeMove(byref play, who, move := "") {
		static wins := [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]
		table := play.table
		available := []
		for _, box in table
			if (box = 2)
				available.push(A_Index)

		if !move
			move := random(available)

		if !Contains(move, available)
			throw Exception("not valid", 400)


		table[move] := who
		for _, win in wins {
			if table[win[1]] = 2
				break
			if (table[win[1]] == table[win[2]] && table[win[2]] == table[win[3]]) {
				play.winner := table[win[1]]
				return
			}
		}
		if (who = play.player) {
			this.makeMove(play, !who)
		}
	}
}
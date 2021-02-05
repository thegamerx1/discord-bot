class command_print extends command_ {
	static owneronly := true
	, cooldown := 0
	, info := "Gets output of a message"
	, args := 2
	, aliases := ["get"]

	call(ctx, args) {
		switch args.length() {
			case 1:
				data := ctx[args[1]]
			case 2:
				data := ctx[args[1]][args[2]]
			case 3:
				data := ctx[args[1]][args[2]][args[3]]
			case 4:
				data := ctx[args[1]][args[2]][args[3]][args[4]]
			case 5:
				data := ctx[args[1]][args[2]][args[3]][args[4]][args[5]]
		}
		debug.print("embed creating")
		embed := new discord.embed("Output", "``````json`n" IsObject(data) ? JSON.dump(data) :  "``````")
		debug.print("embed ready")
		ctx.reply(embed)
		debug.print("print ended")
	}
}
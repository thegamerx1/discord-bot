class command_fox extends DiscoBot.command {
	cooldown := 4
	info := "Floofy"
	aliases := ["foxy", "floof"]
	category := "Fun"

	call(ctx, args) {
		static API := "https://randomfox.ca/floof/"
		http := new requests("get", API,, true)
		http.OnFinished := ObjBindMethod(this, "response", ctx)
		http.send()
	}

	response(ctx, http) {
		if http.status != 200
			this.except(ctx, "Error " http.status)
		ctx.reply(http.json().image)
	}
}
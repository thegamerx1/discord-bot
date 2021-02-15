class command_duck extends DiscoBot.command {
	static cooldown := 1
	, info := "Gets a duck for you"
	, aliases := ["quack", "ducky"]
	, category := "Fun"

	call(ctx, args) {
		static API := "https://random-d.uk/api/v1/random"
		ctx.typing()
		http := new requests("get", API,, true)
		http.OnFinished := ObjBindMethod(this, "response", ctx)
		http.send()
	}

	response(ctx, http) {
		if http.status != 200
			this.except(ctx, "Error " http.status)
		ctx.reply(http.json().url)
	}
}
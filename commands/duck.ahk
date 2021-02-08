class command_duck extends command_ {
	static owneronly := false
	, cooldown := 1
	, info := "Gets a duck for you"
	, aliases := ["quack", "ducky"]

	call(ctx, args) {
		static API := "https://random-d.uk/api/v1/random"
		ctx.typing()
		http := new requests("get", API,, true)
		http.OnFinished := ObjBindMethod(this, "response", ctx)
		http.send()
	}

	response(ctx, http) {
		if http.status != 200
			return ctx.reply("Error " http.status)
		ctx.reply(http.json().url)
	}
}
class command_duck extends DiscoBase.command {
	cooldown := 4
	info := "Gets a duck for you"
	aliases := ["quack", "ducky"]

	call(ctx, args) {
		static API := "https://random-d.uk/api/v1/random"
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
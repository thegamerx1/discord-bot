class command_fox extends command_ {
	static cooldown := 1
	, info := "Gets a cat for you"
	, aliases := ["foxy", "floof"]
	, permissions := ["EMBED_LINKS"]


	call(ctx, args) {
		static API := "https://randomfox.ca/floof/"
		ctx.typing()
		http := new requests("get", API,, true)
		http.OnFinished := ObjBindMethod(this, "response", ctx)
		http.send()
	}

	response(ctx, http) {
		if http.status != 200
			return ctx.reply("Error " http.status)
		ctx.reply(http.json().image)
	}
}
class command_cat extends DiscoBot.command {
	static cooldown := 1
	, info := "Gets a cat for you"
	, aliases := ["meow"]
	, category := "Fun"


	call(ctx, args) {
		static API := "https://api.thecatapi.com/v1/images/search"
		ctx.typing()
		http := new requests("get", API,, true)
		http.headers["x-api-key"] := this.bot.bot.CATAPI_KEY
		http.OnFinished := ObjBindMethod(this, "response", ctx)
		http.send()
	}

	response(ctx, http) {
		if http.status != 200
			this.except(ctx, "Error " http.status)
		ctx.reply(http.json()[1].url)
	}
}
class command_duck extends command_ {
	static owneronly := false
	, cooldown := 1
	, info := "Gets a duck for you"
	, aliases := ["quack"]

	call(ctx, args) {
		static API := "https://random-d.uk/api/v1/random"
		ctx.typing()
		http := new requests("get", API)
		httpout := http.send()
		httpjson := httpout.json()
		ctx.reply(httpjson.url)
	}
}
class command_dog extends command_ {
	static cooldown := 1
	, info := "Gets a cat for you"
	, aliases := ["woof", "doggo"]

	, category := "Fun"


	call(ctx, args) {
		static API := "https://random.dog/woof.json"
		ctx.typing()
		; TODO  checky
		http := new requests("get", API,, true)
		http.headers["filter"] := "mp4"
		http.OnFinished := ObjBindMethod(this, "response", ctx)
		http.send()
	}

	response(ctx, http) {
		if http.status != 200
			return ctx.reply("Error " http.status)
		ctx.reply(http.json().url)
	}
}
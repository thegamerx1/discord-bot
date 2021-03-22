class command_dog extends DiscoBase.command {
	cooldown := 4
	info := "Prints doggo"
	aliases := ["woof", "doggo"]

	call(ctx, args) {
		static API := "https://random.dog/woof.json?filter=mp4,webm"
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
class command_code extends command_ {
	static cooldown := 2
	, info := "Gets code of a command"

	call(ctx, args := "") {
		if (regex(args, "\.\\\/"))
			return ctx.react("⛔")

		file := (args = "bot") ? "bot.ahk" : "commands\" args ".ahk"

		try {
			FileRead code, % file
		} catch e {
			debug.print(e)
			return ctx.react("❌")
		}
		if (StrLen(code) > 1500)
			return ctx.reply("too long!")
		; TODO: FIX
		ctx.reply("``````ahk`n" StrReplace(code, "``", "​``") "``````"-)
	}
}
#Include <base64>
class command_ahk extends DiscoBot.command {
	static cooldown := 5
	, info := "Runs code through CloudAHK"
	, args := [{optional: false, name: "code"}]
	, category := "Code"


	start() {
		this.auth := "Basic " this.SET.keys.cloudahk
		this.pasteCache := {}
	}

	call(ctx, args) {
		static API := "https://p.ahkscript.org/?r={}"
		static regex := "^``+(?<lang>\w+)?\n(?<code>.*?)``+$"
		static pasteRegex := "p\.ahkscript\.org\/\?\w\=(?<id>\w+)"

		match := regex(args[1], regex, "sm")
		code := match.code
		if !match
			code := args[1]

		ctx.typing()
		if match := regex(code, pasteRegex, "i") {
			if this.pasteCache[match.id]
				return this.gotCode(ctx, this.pasteCache[match.id])
			http := new requests("get", format(API, match.id),, true)
			http.onFinished := ObjBindMethod(this, "gotCodeResponse", ctx, match.id)
			http.send()
			return
		}
		this.gotCode(ctx, code)
	}

	gotCodeResponse(ctx, id, http) {
		if http.status != 200
			this.except(ctx, "Error getting code")

		if StrLen(http.text) > 100000
			this.except(ctx, "What the fuck does that link contain??")

		this.pasteCache[id] := http.text
		this.gotCode(ctx, http.text)
	}

	gotCode(ctx, code) {
		static API := "https://cloudahk.com/api/v1/language/ahk/run"
		cont := new Counter(, true)
		http := new requests("post", API,, true)
		http.headers["Authorization"] := this.auth
		http.onFinished := ObjBindMethod(this, "response", ctx, cont)
		http.send(code)
	}

	response(ctx, cont, http) {
		if http.status != 200
			this.except(ctx, "Something went wrong")

		hjson := http.json()
		data := {}
		data.length := StrLen(hjson.stdout)
		data.lines := StrSplit(hjson.stdout, "`n", "`r").length()
		data.time := round(hjson.time,2) "s"
		if (data.time = "0.00s")
			data.time := "Timed Out"

		if (data.length > 1850 || data.lines > 14) {
			if (data.length > 8000)
				this.except(ctx, "why the fuck is the output " data.length  " characters?")

			http := new requests("POST", "https://p.ahkscript.org/",, true)
			http.headers["Content-Type"] := "application/x-www-form-urlencoded"
			http.onFinished := ObjBindMethod(this, "toolongreply", ctx, data, cont)
			http.send(requests.encode({code: hjson.stdout}))
			return
		}

		data.content := discord.utils.codeblock("autoit", hjson.stdout)
		this.reply(ctx, data, cont)
	}

	toolongreply(ctx, data, cont, http) {
		if (http.status != 200 || !http.url)
			this.except(ctx, "Uploading file went wrong")


		data.content := http.url
		this.reply(ctx, data, cont, true)
	}

	reply(ctx, data, cont, isPaste := false) {
		embed := new discord.embed(,isPaste ? data.content : "", 0x21633F)
		if !isPaste
			embed.setContent(data.content)

		embed.addField("Chars", data.length, true)
		embed.addField("Lines", data.lines, true)
		embed.addField("User wait", Round(cont.get()/1000, 2) "s", true)
		ctx.reply(embed)
	}
}
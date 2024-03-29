#include <base64>
class command_run extends DiscoBase.command {
	cooldown := 2
	cooldownper := 15
	info := "Runs code through CloudAHK"
	infolong := "Supports multiple languages: bash, python, fish, node, perl, php"
	args := [{optional: false, name: "codeblock"}]
	aliases := ["ahk"]

	start() {
		this.auth := "Basic " base64Enc(this.SET.keys.cloudahk)
		this.pasteCache := {}
	}

	call(ctx, args) {
		static API := "https://p.ahkscript.org/?r="
		static pasteRegex := "p\.ahkscript\.org\/\?\w\=(?<id>\w+)"
		static langs := [{names: ["bash", "sh"], head: "bin/bash"}
						,{names: ["py2"], head: "usr/bin/env python"}
						,{names: ["py", "python"], head: "usr/bin/env python3"}
						,{names: ["fish"], head: "usr/bin/env fish"}
						,{names: ["node", "js"], head: "usr/bin/env node"}
						,{names: ["perl"], head: "usr/bin/env perl"}
						,{names: ["php"], head: "usr/bin/env php"}]

		ctx.typing()
		code := discord.utils.getCodeblock(args[1])
		if (code.lang)
			for _, value in langs
				for _, lang in value.names
					if code.lang = lang {
						code.code := "#!/" value.head "`n" code.code
						break
					}

		if match := regex(code.code, pasteRegex, "i") {
			if this.pasteCache[match.id]
				return this.gotCode(ctx, this.pasteCache[match.id])
			http := new requests("get", API match.id,, true)
			http.onFinished := ObjBindMethod(this, "gotCodeResponse", ctx, match.id)
			http.send()
			return
		}
		this.gotCode(ctx, code.code)
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
		static API := "https://cloudahk.com/api/v0/ahk/run"
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
		data.length := StrLen(hjson.stdout)-1
		stripped := StripNewline(hjson.stdout)
		data.lines := StrSplit(StripNewline(hjson.stdout), "`n", "`r").length()
		data.time := round(hjson.time,2) "s"
		; data.time := Round(cont.get()/1000,2) "s"
		if (data.time = "0.00s")
			data.time := "Timed Out"

		if (data.length > 1200 || data.lines > 16) {
			if (data.length > 16000)
				this.except(ctx, "why the fuck is the output " data.length  " characters?")

			http := new requests("POST", "https://p.ahkscript.org/",, true)
			http.headers["Content-Type"] := "application/x-www-form-urlencoded"
			http.onFinished := ObjBindMethod(this, "toolongreply", ctx, data, cont)
			http.send(urlCode.encodeParams({code: hjson.stdout}))
			return
		}

		data.content := discord.utils.codeblock("ahk", hjson.stdout)
		this.reply(ctx, data, cont)
	}

	toolongreply(ctx, data, cont, http) {
		if (http.status != 200 || !http.url)
			this.except(ctx, "Uploading file went wrong")


		data.content := http.url
		this.reply(ctx, data, cont, true)
	}

	reply(ctx, data, cont, paste := false) {
		embed := new discord.embed(,paste ? data.content : "", 0x21633F)
		if !paste
			embed.setContent(data.content)

		embed.addField("Lines", Max(data.lines, 0), true)
		embed.addField("Chars", data.length, true)
		embed.addField("Run Time", data.time, true)
		ctx.reply(embed)
	}
}
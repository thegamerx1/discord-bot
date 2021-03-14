class command_google extends DiscoBase.command {
	owneronly := true
	info := "Gets google results"
	args := [{name: "query"}]

	call(ctx, args) {
		ctx.typing()
		http := new requests("get", "https://google.com/search", {hl: "en", safe: "on", q: args[1]}, true)
		http.onFinished := ObjBindMethod(this, "response", ctx)
		http.send()
	}

	response(ctx, http) {
		static result := "**[{}]({})**`n_{}_..`n"
		if (http.status != 200)
			this.except(ctx, "Error " http.status)
		html := new HtmlFile(http.text)
		out := ""
		loops := 0
		for _, value in html.each(html.qsa(".g")) {
			if loops > 3
				break
			title := value.querySelector("h3").textContent
			desc := SubStr(value.querySelector("div > span > span").textContent,1,60)
			if !(title && desc)
				continue
			loops++
			url := value.querySelector("a").href
			out .= format(result, title, url, desc)
		}
		embed := new discord.embed("Search", out)
		ctx.reply(embed)
	}
}
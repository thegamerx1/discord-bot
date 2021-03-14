class command_dogecoin extends DiscoBase.command {
	cooldown := 5
	disabled := true
	info := "Gets dogecoin value"
	aliases := ["doge"]

	call(ctx, args) {
		static API := "https://api.wazirx.com/api/v2/tickers/dogeusdt"
		http := new requests("get", API,, true)
		http.OnFinished := ObjBindMethod(this, "response", ctx)
		http.send()
	}

	response(ctx, http) {
		static format := "*{}*: ``{}```n"
		if http.status != 200
			this.except(ctx, "Error " http.status)
		data := http.json()
		embed := new discord.embed(":chart_with_upwards_trend: Dogecoin", format(format, "Top bid order price", data.ticker.buy) format(format, "Top ask order price", data.ticker.sell) format(format, "Lowest price of base asset", data.ticker.low) format(format, "Highest price of base asset", data.ticker.High) format(format, "Traded volume", data.ticker.vol))
		embed.setTimestamp(discord.utils.toISO(Unix2Miss(data.at)))
		ctx.reply(embed)
	}
}
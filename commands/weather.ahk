class command_weather extends command_ {
	static cooldown := 2
	, info := "Gets the weather"
	, args := [{optional: false, name: "site"}]
	, permissions := ["EMBED_LINKS"]


	call(ctx, args) {
		static API := "https://api.openweathermap.org/data/2.5/weather?q={}&appid={}&units=metric"
		http := new requests("GET", format(API, args[1], this.bot.bot.WEATHER_KEY),, true)
		http.onFinished := ObjBindMethod(this, "response", ctx)
		http.send()
	}

	response(ctx, http) {
		static iconurl := "http://openweathermap.org/img/wn/{}@2x.png"
		static url := "https://openweathermap.org/city/{}"
		if http.status != 200
			return ctx.react("bot_no")

		data := http.json()
		http := ""

		embed := new discord.embed("Weather for " data.name ", " data.sys.country, format("{:T}", data.weather[1].description))
		embed.setUrl(format(url, data.id))
		embed.addField("Temperature", data.main.temp Chr(176) "C", true)
		embed.addField("Feels like", data.main.feels_like Chr(176) "C", true)
		embed.addField("Humidity", data.main.humidity "%", true)
		embed.addField("Wind", data.wind.speed "m/s " data.wind.deg Chr(176), true)
		embed.addField("Precipitation", (data.rain.1h ? data.rain.1h "mm": "No precipitation"), true)
		if data.snow
			embed.addField("Snow", data.snow.1h "mm", true)
		embed.addField("Clouds", data.clouds.all "%", true)
		embed.setThumbnail(format(iconurl, data.weather[1].icon))
		FormatTime calc, % Unix2Miss(data.dt), yyyy-MM-ddTHH:mm:ss.000Z
		embed.setTimestamp(calc)
		embed.setFooter("Current weather")

		ctx.reply(embed)
	}
}
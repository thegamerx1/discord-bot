#include <dataframe>
class command_gateway extends DiscoBot.command {
	static owneronly := true
	, info := "Gets gateway log"
	, category := "Owner"

	start() {
		this.events := {}
	}

	call(ctx, args) {
		frame := new dataframe(dataframe.fromObj(this.events, ["EVENT", "CALLS"]))
		total := 0
		unique := 0
		for _, count in this.events {
			total += count
			unique++
		}
		embed := new discord.embed(,"``````AsciiDoc`n" frame.get() "``````")
		embed.addField("Total events", total, true)
		embed.addField("Unique events", unique, true)
		ctx.reply(embed)
	}

	_event(event, data) {
		if !this.events[event]
			this.events[event] := 0
		this.events[event]++
	}
}
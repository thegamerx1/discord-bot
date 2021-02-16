class command_8ball extends DiscoBot.command {
	static cooldown := 60
	, info := "Asks the magic 8 Ball!"
	, aliases := ["8"]
	, category := "Fun"

	call(ctx, args) {
		static BALL_RESPONSES := ["It is certain", "It is decidedly so", "Without a doubt", "Yes definitely", "You may rely on it"
			,"As I see it, yes", "Most likely", "Outlook good", "Yes"
			,"Signs point to yes", "Reply hazy try again", "Ask again later", "Better not tell you now"
			,"Cannot predict now", "Concentrate and ask again"
			,"Don't count on it", "My reply is no", "My sources say no", "Outlook not so good", "Very doubtful"]

		msg := ctx.reply(new discord.embed(, "Shaking.."))
		TimeOnce(ObjBindMethod(msg, "edit", new discord.embed(, "***:8ball:  " random(BALL_RESPONSES) "***")), 3000)
	}
}
class command_8ball extends DiscoBase.command {
	cooldown := 1
	cooldownper := 30
	info := "Asks the magic 8 Ball!"
	aliases := ["8"]
	args := [{name: "question"}]

	call(ctx, args) {
		static BALL_RESPONSES := ["It is certain", "It is decidedly so", "Without a doubt", "Yes definitely", "You may rely on it"
			,"As I see it, yes", "Most likely", "Outlook good", "Yes"
			,"Signs point to yes", "Reply hazy try again", "Ask again later", "Better not tell you now"
			,"Cannot predict now", "Concentrate and ask again"
			,"Don't count on it", "My reply is no", "My sources say no", "Outlook not so good", "Very doubtful"]

		if !InStr(ctx.message, "?")
			this.except(ctx, "8 Ball didn't find the question")


		msg := ctx.reply(new discord.embed(, "Shaking.."))
		TimeOnce(ObjBindMethod(msg, "edit", new discord.embed(, "***:8ball:  " random(BALL_RESPONSES) "***")), 3000)
	}

	onCooldown(ctx) {
		ctx.reply(new discord.embed(, "**You may only ask the magic 8 Ball every 30 seconds!**"))
	}
}
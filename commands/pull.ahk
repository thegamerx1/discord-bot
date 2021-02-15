#include <RunCMD>
class command_pull extends DiscoBot.command {
	static owneronly := true
	, info := "Gets code from github"
	, category := "Owner"

	call(ctx, args) {
		if !this.bot.bot.release
			this.except("pull only works on release mode!")
		ctx.typing()
		output := RunCMD("pullall.cmd")
		msg := ctx.reply(discord.utils.codeblock("git", output))
		msg.react(ErrorLevel ? "bot_no" : "bot_ok")
	}
}
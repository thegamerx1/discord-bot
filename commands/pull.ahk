#include <RunCMD>
class command_pull extends DiscoBot.command {
	static owneronly := true
	, info := "Gets code from github"
	, category := "Owner"

	call(ctx, args) {
		ctx.typing()
		ctx.reply(discord.utils.codeblock("git", RunCMD("pullall.cmd")
	}
}
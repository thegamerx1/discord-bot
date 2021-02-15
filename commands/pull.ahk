#include <RunCMD>
class command_pull extends DiscoBot.command {
	static owneronly := true
	, info := "Gets code from github"
	, category := "Owner"

	call(ctx, args) {
		ctx.typing()
		output := RunCMD("pullall.cmd")
		ctx.reply("``````" discord.utils.sanitize(output) "``````")
	}
}
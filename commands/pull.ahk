#include <RunCMD>
class command_pull extends DiscoBot.command {
	owneronly := true
	info := "Gets code from github"
	category := "Owner"

	call(ctx, args) {
		if !this.SET.release
			this.except(ctx, "pull only works on release mode!")
		ctx.typing()
		output := RunCMD("pullall.cmd")
		msg := ctx.reply(discord.utils.codeblock("git", output,, "No changes"))
	}
}
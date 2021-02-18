#include <RunCMD>
class command_pull extends DiscoBot.command {
	owneronly := true
	info := "Gets code from github"
	category := "Owner"
	commands := [{name: "restart"}]

	c_restart(ctx) {
		msg := this.call(ctx, args)
		this.bot.executeCommand("reload", "call", msg, args)
	}

	call(ctx) {
		if !this.SET.release
			this.except(ctx, "pull only works on release mode!")
		ctx.typing()
		output := RunCMD("pullall.cmd")
		ctx.reply(discord.utils.codeblock("git", output))
	}
}
#include <RunCMD>
class command_pull extends DiscoBase.command {
	owneronly := true
	info := "Gets code from github"

	call(ctx) {
		if !this.SET.release
			this.except(ctx, "Pull only works on release mode!")
		ctx.typing()
		path := StrSplit(A_WorkingDir, ["/", "\"])
		path.pop()
		path := Array2String(path, "/")
		output := RunCMD("pullall.cmd",,, path)
		ctx.reply(discord.utils.codeblock("git", output))
	}
}
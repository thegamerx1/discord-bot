#include <socket>
class dashboardServer {
	init(port, ip := "localhost") {
		this.server := new SocketTCP()
		this.server.OnAccept := this.OnAccept.Bind(this)
		this.server.Bind(["127.0.0.1", port])
		this.server.Listen()
		this.log := debug.space("Dash_Serv")
		this.log("Ready")
	}

	OnAccept(serv) {
		sock := serv.Accept()
		text := Sock.RecvText()
		try {
			query := JSON.load(text)
		} catch {
			sock.disconnect()
			return
		}
		request := query.data
		query := query.query
		api := DiscoBot.api
		code := 200
		data := ""
		this.log("request for " query)
		switch query {
			case "guild":
				guild := api.getGuild(request.id)
				if guild {
					gdata := DiscoBot.getGuild(request.id)
					channels := []
					for _, val in guild.channels {
						if (val.type = 0)
							channels.push({name: val.name, id: val.id})
					}
					commands := []
					for name, cmd in Discobot.commands {
						commands.push(name)
					}
					data := {id: guild.id, commands: commands, channels: channels
							,data: {logging: {edits: gdata.logging.edits ""
									,joins: gdata.logging.joins ""
									,deletes: gdata.logging.deletes ""}
							,disabled_commands: gdata.disabled_commands}}
				} else {
					code := 404
				}
			case "save":
				guild := DiscoBot.getGuild(request.id)
				if (request.type == "commands") {
					guild.disabled_commands := request.data.disabled_commands
				} else {
					for key, value in request.data
						guild[request.type][key] := value
				}
			case "isIn":
				data := []
				for _, guild in request.guilds {
					if api.getGuild(guild.id)
						data.push(guild)
				}
			case "alive":
				data := {alive: true}
			default:
				code := 400
		}

		data := JSON.dump(data ? data : code)
		Sock.SendText(data)
		Sock.Disconnect()
	}
}
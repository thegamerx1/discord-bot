#include <socket>
class dashboardServer {
	init(port, ip := "localhost") {
		this.server := new SocketTCP()
		this.server.OnAccept := this.OnAccept.Bind(this)
		this.server.Bind([ip, port])
		this.server.Listen()
		this.log := debug.space("Dash_Serv")
		this.log("Ready")
	}

	OnAccept(serv) {
		sock := serv.Accept()
		text := Sock.RecvText()
		query := JSON.load(text)
		request := query.data
		query := query.query
		api := DiscoBot.api
		code := 200
		data := ""
		switch query {
			case "guild":
				guild := api.getGuild(request.id)
				if guild {
					guilddata := DiscoBot.getGuild(request.id)
					channels := []
					for _, val in guild.channels {
						if (val.type = 0)
							channels.push({name: val.name, id: val.id})
					}
					data := {channels: channels, form: {editschannel: guilddata.logging.edits "", joinschannel: guilddata.logging.joins ""}, id: guild.id}
				} else {
					code := 404
				}
			case "save":
				guild := DiscoBot.getGuild(request.id)
				guild.logging.edits := request.editschannel
				guild.logging.joins := request.joinschannel
				; guilddata.disabled_commands := request.disabled_commands
			case "isIn":
				data := []
				for i, guild in request.guilds {
					if api.getGuild(guild)
						data.push(i)
				}
			default:
				code := 400
		}

		data := JSON.dump(data ? data : code)
		Sock.SendText(data)
		Sock.Disconnect()
	}
}
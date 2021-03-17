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
					data := {channels: channels, form: {editchannel: guilddata.logging.edits ""}}
				} else {
					code := 404
				}
			case "isIn":
				guild := api.getGuild(request.id)
				data := {isIn: !!guild.getMember(request.user)}
			default:
				code := 400
		}
		data := JSON.dump(data ? data : code)
		Sock.SendText(data)
		Sock.Disconnect()
	}
}
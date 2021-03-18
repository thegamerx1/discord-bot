class dashboardClient {
	init(port, ip := "localhost") {
		this.port := port
		this.ip := ip
	}

	query(query, request) {
		Sock := new SocketTCP()
		Sock.Connect([this.ip, this.port])
		Sock.SendText(JSON.dump({query: query, data: request}))
		try {
			data := Sock.RecvText()
		} catch e {
			return data
		}
		Sock.Disconnect()
		return JSON.load(data)
	}
}
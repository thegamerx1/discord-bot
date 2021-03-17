class dashboardClient {
	init(port, ip := "localhost") {
		this.port := port
		this.ip := ip
	}

	query(what) {
		Sock := new SocketTCP()
		Sock.Connect([this.ip, this.port])
		Sock.SendText(JSON.dump(what))
		try {
			data := Sock.RecvText()
		} catch e {
			return data
		}
		Sock.Disconnect()
		return data
	}
}
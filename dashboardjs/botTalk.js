const net = require("net")

class connect {
	init(port, host) {
		this.port = port
		this.host = host
	}

	async ask(query, data) {
		return await new Promise((resolve, reject) => {
			const socket = net.createConnection({ port: this.port, host: this.host }, () => {
				socket.write(JSON.stringify({query: query, data: data}))
			})

			socket.on("data", async data => {
				data = data.toString()
				try {
					data = JSON.parse(data)
				} catch {
					reject(data)
				}
				resolve(data)
			})

			socket.on("error", err => {
				reject(err)
			})
		})
	}
}

module.exports = new connect
const botTalk = require("./botTalk")
const DiscordOauth2 = require("discord-oauth2")
botTalk.init(21901, "localhost")

const oauth = new DiscordOauth2({
	clientId: process.env.client_id,
    clientSecret: process.env.client_secret,
    redirectUri: process.env.redirect_uri
})

function notLoggedIn(req) {
	return !(req.session.user && req.session.token)
}

module.exports.index = (req, res) => {
	res.render("index", {user: req.session.user, title: "Home"})
}

module.exports.dashboard = async (req, res) => {
	if (notLoggedIn(req)) {
		res.redirect("/login")
		return
	}
	res.render("dashboard", {user: req.session.user, title: "Dashboard", guilds: req.session.guilds})
}


module.exports.dashConfig = async (req, res) => {
	if (notLoggedIn(req)) {
		res.redirect("/login")
		return
	}
	var found = false
	for (const guild of req.session.guilds) {
		if (guild.id == req.params.id) {
			found = guild.id
		}
	}
	if (found) {
		try {
			const data = await botTalk.ask("guild", {id: found})
			res.render("dashconf", {user: req.session.user, title: "Dashboard", guild: data})
		} catch (e) {
			res.statusCode(e)
			return
		}
	} else {
		res.redirect("/")
	}
}

module.exports.dashSave = async (req, res) => {
	const required = ["joinschannel", "editschannel"]
	if (notLoggedIn(req)) {
		res.redirect("/login")
		return
	}
	var found = false
	for (const guild of req.session.guilds) {
		if (guild.id == req.params.id) {
			found = guild.id
		}
	}

	if (!found)
		return res.status(401).send("")

	for (const value of required) {
		if (!req.body[value])
			return res.status(400).send("")
	}

	try {
		await botTalk.ask("save", {data: req.body, id: found})
		res.status(201).send("")
	} catch (e) {
		console.error(e)
		res.status(500).send("")
	}
}

module.exports.login = (req, res) => {
	if (req.query.code) {
		oauth.tokenRequest({scope: process.env.scopes, code: req.query.code, grantType: "authorization_code"})
		.then(async token => {
			req.session.token = token
			const [user, guilds] = await Promise.all([
				oauth.getUser(token.access_token),
				oauth.getUserGuilds(token.access_token)
			])

			try {
				req.session.guilds = await botTalk.ask("IsIn", {guilds: guilds})
			} catch (e) {
				res.statusCode(e)
				return
			}

			req.session.user = user
			res.redirect("/dashboard")
		}).catch(e => {
			console.error(e)
			res.redirect("/login")
		})
		return
	}
	res.redirect(oauth.generateAuthUrl({scope: process.env.scopes}))
}

module.exports.logout = async (req, res) => {
	await req.session.destroy()
	res.redirect("/")
}
module.exports.reload = async (req, res) => {
	await req.session.destroy()
	res.redirect("/login")
}
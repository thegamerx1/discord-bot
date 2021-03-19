require("dotenv").config()
const express = require("express")
const session = require("express-session")
const Handlebars = require("express-handlebars")

const DiscordOauth2 = require("discord-oauth2")

const botTalk = require("./botTalk")
const oauth = new DiscordOauth2({
    clientId: process.env.client_id,
    clientSecret: process.env.client_secret,
    redirectUri: process.env.redirect_uri
})
botTalk.init(21901, "localhost")

const app = express()

app.engine("hbs", Handlebars({
	defaultLayout: "main",
	extname: ".hbs",
	helpers: {
		eq: (v1, v2) => v1 === v2,
		dump: (obj) => JSON.stringify(obj)
	}
}))

app.use(express.static("public/"))

app.use(session({secret: "whathefuckisthisforlmaoa"}))
app.use(express.urlencoded({extended: true}))
app.set("view engine", "hbs")

app.get("/", (req, res) => {
	res.render("index", {user: req.session.user, title: "Home"})
})

app.get("/dashboard", async (req, res) => {
	if (!req.session.user) {
		res.redirect("/login")
		return
	}
	res.render("dashboard", {user: req.session.user, title: "Dashboard", guilds: req.session.guilds})
})

app.get("/dashboard/:id", async (req, res) => {
	if (!req.session.user) {
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
})

app.get("/login", (req, res) => {
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
})

app.post("/save/:id", async (req, res) => {
	const required = ["joinschannel", "editschannel"]
	if (!req.session.user) {
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
})

app.get("/logout", async (req, res) => {
	await req.session.destroy()
	res.redirect("/")
})

app.get("/reloadguilds", async (req, res) => {
	await req.session.destroy()
	res.redirect("/login")
})


app.listen(80, () => {
	console.log(`Listening at http://localhost:80`)
})
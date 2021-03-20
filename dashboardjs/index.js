require("dotenv").config()
const routes = require("./routes")

const express = require("express")
const session = require("express-session")
const helmet = require("helmet")
const https = require("https")
const http = require("http")
const Handlebars = require("express-handlebars")
const compression = require("compression")
const fs = require("fs")

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
app.use(compression())
app.use(helmet({
	contentSecurityPolicy: false
}))

app.use(session({
	secret: process.env.secret,
	resave: true,
	saveUninitialized: true,
	httpOnly: true
}))

app.use(express.urlencoded({extended: true}))
app.set("view engine", "hbs")


app.get("/", routes.index)
app.get("/dashboard", routes.dashboard)
app.get("/dashboard/:id", routes.dashConfig)
app.get("/login", routes.login)
app.post("/save/:id", routes.dashSave)
app.get("/logout", routes.logout)
app.get("/reload", routes.reload)
app.get("*", routes.notfound)

if (process.env.NODE_ENV == "production") {
	const redirect = express()
	redirect.get("*", (req, res) => {
		res.redirect("https://" + req.headers.host + req.url)
	})

	const keys = {key, cert, ca} = [
		fs.readFileSync("keys/private.key", "utf-8"),
		fs.readFileSync("keys/certificate.crt", "utf-8"),
		fs.readFileSync("keys/ca_bundle.crt", "utf-8")
	]

	const httpSERV = http.createServer(redirect).listen(80)
	const httpsSERV = https.createServer(keys, app).listen(443)
} else {
	const httpSERV = http.createServer(app).listen(80)
}
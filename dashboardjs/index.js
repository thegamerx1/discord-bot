require("dotenv").config()
const routes = require("./routes")

const express = require("express")
const session = require("express-session")
const helmet = require("helmet")
const Handlebars = require("express-handlebars")
const compression = require("compression")

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
	store
}))

app.use(express.urlencoded({extended: true}))
app.set("view engine", "hbs")


app.get("/", routes.index)
app.get("/dashboard", routes.dashboard)
app.get("/dashboard/:id", routes.dashConfig)
app.get("/login", routes.login)
app.post("/save/:id", routes.dashSave)

app.get("/logout", routes.logout)

app.get("/reloadguilds", routes.reload)


app.listen(80, () => {
	console.log(`Listening at http://localhost:80`)
})
const login = document.getElementById("login-template")
var userRenderer = Handlebars.compile(login.innerHTML)
login.insertAdjacentHTML("beforebegin", userRenderer(DATA.user))


const dashboardContainer = document.getElementById("dashboard")
const dashboardForm = document.getElementById("dashboardform")
const serverSelector = document.getElementById("serverSelect")

dashboardForm.addEventListener("submit", handleDashForm);
const guildContainer = document.getElementById("guilds")
var renderServer = Handlebars.compile(document.getElementById("server-template").innerHTML)

if (DATA.guilds.length < 0) {
	document.getElementById("addit").classList.remove("d-none")
}
DATA.guilds.forEach((guild) => {
	guildContainer.insertAdjacentHTML("beforeend", renderServer(guild))
})

function setDashboard(btn) {
	let id = btn["data-id"]
	serverSelector.classList.add("d-none")
	dashboardContainer.classList.remove("d-none")
}

function handleDashForm(e) {
    if (e.preventDefault) e.preventDefault()

	const form = new FormData(e.target)
	console.log(form)
	const formObject = Object.fromEntries(form)
	console.log(formObject)
/* 	let http = new XMLHttpRequest()
	Http.open("GET", "/getguild?id=")
	Http.send()

	Http.onreadystatechange = (e) => {
	  console.log(Http.responseText)
	} */
    return false
}
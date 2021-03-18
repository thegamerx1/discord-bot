const login = $("#login-template")
var userRenderer = Handlebars.compile(login.html())
login.replaceWith(userRenderer(DATA.user))
let path = window.location.href
let active = $("nav a[href=\""+ path.substr(path.lastIndexOf("/")) + "\"]")
active.parent().addClass("active")
active.href = "#"

function changeUrl(url, title) {
	window.history.pushState("data", title, url)
}

function setProgress(perc) {
	let progress = $("#pageProgress")
	if (perc > 0) {
		progress.parent().removeClass("d-none")
		progress.width(perc + "%")
		if (perc == 100) {
			setTimeout(setProgress.bind(0), 100)
		}
	} else {
		progress.parent().addClass("d-none")
	}
}
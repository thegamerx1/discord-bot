lastrequest = ""
// function move() {
// 	let date = new Date()
// 	if (date - lastrequest > 120) {
// 		var xhttp = new XMLHttpRequest()
// 		xhttp.onreadystatechange = function() {
// 			if (xhttp.readyState == 4 && xhttp.status == 200) {
// 				document.getElementById("mouse").innerHTML = xhttp.responseText
// 			}
// 		}
// 		xhttp.open("GET", "mouse", true)
// 		xhttp.send()
// 		lastrequest = date
// 	}
// }

function signin() {
	window.location.replace("https://discord.com/api/oauth2/authorize?client_id=809818429284155442&redirect_uri=http%3A%2F%2Flocalhost%2Fdiscordredirect&response_type=code&scope=identify%20guilds")
}
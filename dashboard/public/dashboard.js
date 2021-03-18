$("#initLoadProgress").width("5%")
// $("#dashboardform").on("submit", handleDashForm)
var renderServer = Handlebars.compile($("#server-template").html())
$.get("/guilds", (data) => {
	$("#initLoadProgress").width("90%")
	data = JSON.parse(data)

	if (data.length < 0 || !Array.isArray(data)) {
		$("#addit").removeClass("d-none")
	} else {
		console.log(data)
		data.forEach((guild) => {
			$("#guilds").append(renderServer(guild))
		})
	}
	$("#initLoadProgress").width("100%")
	setTimeout(() => {
		$("#initLoadProgress").parent().hide()
	}, 50)
}).fail( () => {
	halfmoon.initStickyAlert({
		content: "Error connecting to server.",
		title: "Server error",
		alertType: "alert-danger",
		fillType: "filled"
	})
})


function setDashboard(btn) {
	var id = $(btn).attr("guild")
	$("#initLoadProgress").width("5%")
	$("#initLoadProgress").parent().show()
	$("#serverSelect").addClass("d-none")
	$("#dashboard").removeClass("d-none")
	$.get("/guild/" + id, data => {
		var dashboard = $("#dashboardform")
		$("#initLoadProgress").width("90%")
		data = JSON.parse(data)
		dashboard.find(".channelSelect").each((i ,e) => {
			data.channels.forEach(channel => {
				e.append(new Option("#" + channel.name, channel.id))
			})
		})
		$.each(data.form, (key, value) => {
			console.log(value.toString())
			dashboard.find("[name=\"" + key +"\"]").val(value.toString())
		})
	}).fail( () => {
		halfmoon.initStickyAlert({
			content: "Error connecting to server.",
			title: "Server error",
			alertType: "alert-danger",
			fillType: "filled"
		})
	})
}

// function handleDashForm(e) {
//     if (e.preventDefault) e.preventDefault()

// 	const form = new FormData(e.target)
// 	console.log(form)
// 	const formObject = Object.fromEntries(form)
// 	console.log(formObject)
// /* 	let http = new XMLHttpRequest()
// 	Http.open("GET", "/getguild?id=")
// 	Http.send()

// 	Http.onreadystatechange = (e) => {
// 	  console.log(Http.responseText)
// 	} */
//     return false
// }
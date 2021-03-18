$(document).ready(() => {
	setProgress(5)
	var renderServer = Handlebars.compile($("#server-template").html())
	$.get("/guilds", (data) => {
		setProgress(90)
		data = JSON.parse(data)

		if (data.length < 0 || !Array.isArray(data)) {
			$("#addit").removeClass("d-none")
		} else {
			console.log(data)
			data.forEach((guild) => {
				$("#guilds").append(renderServer(guild))
			})
		}
		setProgress(100)
	}).fail(() => {
		halfmoon.initStickyAlert({
			content: "Error getting guilds.",
			title: "Error",
			alertType: "alert-danger"
		})
	})
})
function setDashboard(id) {
	location.href = "/dashboard/" + id
}
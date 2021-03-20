dashboard = $("#dashboard")
dashboard.on("submit", (e) => {
	e.preventDefault()
	setProgress(5)
	let data = new FormData(e.target)
	let out = {}
	data.forEach((value, key) => {
		out[key] = value
	})

	$.post("/save/" + id, out, () => {
		setProgress(100)
	}).fail(()=>{
		halfmoon.initStickyAlert({
			content: "Error saving data.",
			title: "Error",
			alertType: "alert-danger"
		})
		setProgress(100)
	})
	setProgress(80)
})

dashboard.find(".channelSelector").each((i ,e) => {
	channels.forEach(channel => {
		e.append(new Option("#" + channel.name, channel.id))
	})
})
$.each(form, (key, value) => {
	dashboard.find("[name=\"" + key +"\"]").val(value)
})
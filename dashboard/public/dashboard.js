$("#dashboard").on("submit", (e) => {
	e.preventDefault()
	setProgress(5)
	let data = new FormData(e.target)
	let out = {}
	data.forEach((value, key) => {
		out[key] = value
	})

	$.post("/save/" + DATA.guild.id, out, () => {
		setProgress(100)
		halfmoon.initStickyAlert({
			content: "Succesfully sent data.",
			title: "Sucess",
			alertType: "alert-success"
		})
	}).fail(()=>{
		halfmoon.initStickyAlert({
			content: "Error sending data.",
			title: "Error",
			alertType: "alert-danger"
		})
		setProgress(100)
	})
	setProgress(80)
})

$("#dashboard .channelSelect").each((i ,e) => {
	channels.forEach(channel => {
		e.append(new Option("#" + channel.name, channel.id))
	})
})
$.each(form, (key, value) => {
	$("#dashboard [name=\"" + key +"\"]").val(value.toString())
})
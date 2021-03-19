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
class command_purge extends command_ {
	static owneronly := true
	, info := "Delet server"

	call(ctx, args) {
		throw Exception("intentional exception", -1)
	}
}
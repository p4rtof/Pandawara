extends Node

var poin = 0
var nyawa = 5
var album_koleksi = []
var bioma_dipilih = 0
var poin_per_bioma = [0, 0, 0]  # ← [hulu, pertengahan, perkotaan]

func reset_game():
	poin = 0
	nyawa = 5
	album_koleksi.clear()
	bioma_dipilih = 0
	# poin_per_bioma TIDAK direset biar progress unlock tetap tersimpan

extends Node

var poin = 0
var nyawa = 5
var album_koleksi = []
var bioma_dipilih = 0
var poin_per_bioma = [0, 0, 0]

var sapu_sapu_ditangkap: int = 0
var target_sapu_sapu_per_bioma: Array = [5, 15, 20]
var target_sapu_sapu: int = 5
var sedang_game_over: bool = false

var bioma_terbuka: int = 0   # ← BARU: bioma tertinggi yang sudah terbuka (0 = cuma DESA)

func reset_game():
	poin = 0
	nyawa = 5
	sapu_sapu_ditangkap = 0
	album_koleksi.clear()
	bioma_dipilih = 0
	sedang_game_over = false
	target_sapu_sapu = target_sapu_sapu_per_bioma[0]
	# bioma_terbuka SENGAJA tidak di-reset, biar progress unlock bioma tetap kesimpen

func buka_bioma_berikutnya():
	if bioma_dipilih + 1 > bioma_terbuka:
		bioma_terbuka = bioma_dipilih + 1

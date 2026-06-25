extends Node

var poin = 0
var nyawa = 5
var album_koleksi = []
var bioma_dipilih = 0
var poin_per_bioma = [0, 0, 0]

var sapu_sapu_ditangkap: int = 0
var target_sapu_sapu: int = 5

func reset_game():
	poin = 0
	nyawa = 5
	sapu_sapu_ditangkap = 0
	album_koleksi.clear()
	bioma_dipilih = 0

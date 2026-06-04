# game_manager.gd
extends Node

signal nyawa_berubah(sisa_nyawa)
signal point_berubah(total_point)
signal game_over

var nyawa: int = 3
var point: int = 0
var koleksi_album: Array = []  # Ikan yang sudah ditemukan


func tangkap_ikan(data: Dictionary):
	if data["adalah_sapu_sapu"]:
		# BENAR! Dapat point
		tambah_point(10)
	else:
		# SALAH! Kurangi nyawa
		kurangi_nyawa()
	
	# Tambah ke album koleksi
	_tambah_koleksi(data)

func tambah_point(nilai: int):
	point += nilai
	emit_signal("point_berubah", point)

func kurangi_nyawa():
	nyawa -= 1
	emit_signal("nyawa_berubah", nyawa)
	if nyawa <= 0:
		emit_signal("game_over")

func _tambah_koleksi(data: Dictionary):
	# Cek apakah sudah ada di koleksi
	var sudah_ada = false
	for item in koleksi_album:
		if item["nama"] == data["nama"]:
			sudah_ada = true
			break
	if not sudah_ada:
		koleksi_album.append(data)

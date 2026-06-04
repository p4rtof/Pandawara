extends Node2D

# Tinggi tiap bioma (sesuaikan tinggi gambarmu)
const TINGGI_BIOMA = 1024

@onready var bioma_list = [$BiomaBersih]

var bioma_aktif = 0

func _ready():
	# Susun bioma ke BAWAH (vertikal)
	for i in bioma_list.size():
		bioma_list[i].position.y = i * TINGGI_BIOMA
		bioma_list[i].position.x = 0

func _process(_delta):
	_cek_pindah_bioma()

func _cek_pindah_bioma():
	# Cari player
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	var player_y = player.global_position.y
	var bioma_baru = int(player_y / TINGGI_BIOMA)
	bioma_baru = clamp(bioma_baru, 0, bioma_list.size() - 1)
	
	if bioma_baru != bioma_aktif:
		bioma_aktif = bioma_baru
		print("Masuk bioma ke: ", bioma_aktif)

extends Control

var album_scene = preload("res://scene/album.tscn")

@onready var koleksi_button = $KoleksiIkan   # ← BARU

func _ready():
	$KembaliButton.pressed.connect(_kembali)
	koleksi_button.pressed.connect(_buka_album)   # ← BARU

	_setup_kartu(0, $HBoxContainer/KartuHulu/GambarCard/ButtonLanjut, null)
	_setup_kartu(1, $HBoxContainer/KartuPertengahan/GambarCard/ButtonLanjut, $HBoxContainer/KartuPertengahan/GambarCard/ColorRect)
	_setup_kartu(2, $HBoxContainer/KartuPerkotaan/GambarCard/ButtonLanjut, $HBoxContainer/KartuPerkotaan/GambarCard/ColorRect)

func _buka_album():   # ← BARU
	get_tree().paused = true
	if get_tree().get_first_node_in_group("album"):
		return
	var album = album_scene.instantiate()
	album.add_to_group("album")
	add_child(album)

func _setup_kartu(index: int, tombol: BaseButton, lock_overlay: ColorRect):
	var terkunci = index > Global.bioma_terbuka

	if lock_overlay:
		lock_overlay.visible = terkunci

	tombol.disabled = terkunci

	if not terkunci:
		tombol.pressed.connect(_pilih_bioma.bind(index))

func _pilih_bioma(index: int):
	Global.bioma_dipilih = index
	Global.sapu_sapu_ditangkap = 0
	Global.nyawa = 5
	Global.sedang_game_over = false
	Global.target_sapu_sapu = Global.target_sapu_sapu_per_bioma[index]

	if Global.siapkan_story_intro(index):
		get_tree().change_scene_to_file("res://scene/story_transisi.tscn")
	else:
		get_tree().change_scene_to_file("res://scene/game_sungai.tscn")

func _kembali():
	get_tree().change_scene_to_file("res://scene/mainmenu.tscn")

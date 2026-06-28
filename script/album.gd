extends Control

@onready var tutup_button = $TutupButton
@onready var card_ikan = $CardIkan
@onready var button_sapu2 = $ScrollContainer/VBoxContainer/ButtonSapu2
@onready var button_mujair = $ScrollContainer/VBoxContainer/ButtonMujair
@onready var button_sapu2_albino = $ScrollContainer/VBoxContainer/ButtonSapu2Albino
@onready var button_mas = $ScrollContainer/VBoxContainer/ButtonMas
@onready var button_sapu2_loreng = $ScrollContainer/VBoxContainer/ButtonSapu2Loreng
@onready var button_lele = $ScrollContainer/VBoxContainer/ButtonLele
@onready var button_buaya = $ScrollContainer/VBoxContainer/ButtonBuaya

func _ready():
	tutup_button.pressed.connect(_tutup_album)
	button_sapu2.pressed.connect(func(): card_ikan.texture = load("res://asset/album_sapu2.png"))
	button_mujair.pressed.connect(func(): card_ikan.texture = load("res://asset/album_mujair.png"))
	button_sapu2_albino.pressed.connect(func(): card_ikan.texture = load("res://asset/album_sapu2albino.png"))
	button_mas.pressed.connect(func(): card_ikan.texture = load("res://asset/album_mas.png"))
	button_sapu2_loreng.pressed.connect(func(): card_ikan.texture = load("res://asset/album_sapu2loreng.png"))
	button_lele.pressed.connect(func(): card_ikan.texture = load("res://asset/album_lele.png"))
	button_buaya.pressed.connect(func(): card_ikan.texture = load("res://asset/album_buaya.png"))

	var group = ButtonGroup.new()
	button_sapu2.button_group = group
	button_mujair.button_group = group
	button_sapu2_albino.button_group = group
	button_mas.button_group = group
	button_sapu2_loreng.button_group = group
	button_lele.button_group = group
	button_buaya.button_group = group

	# Semua lock dulu sebelum dicek
	_set_semua_locked()

	# Buka tombol yang sudah ditangkap
	button_sapu2.disabled = not _sudah_ditangkap("Sapu-sapu Biasa")
	button_mujair.disabled = not _sudah_ditangkap("Mujair")
	button_sapu2_albino.disabled = not _sudah_ditangkap("Sapu-sapu Albino")
	button_mas.disabled = not _sudah_ditangkap("Mas")
	button_sapu2_loreng.disabled = not _sudah_ditangkap("Sapu-sapu Loreng")
	button_lele.disabled = not _sudah_ditangkap("Lele")
	button_buaya.disabled = not _sudah_ditangkap("Buaya")

	# Default card locked
	card_ikan.texture = load("res://asset/album_locked.png")

func _set_semua_locked():
	button_sapu2.disabled = true
	button_mujair.disabled = true
	button_sapu2_albino.disabled = true
	button_mas.disabled = true
	button_sapu2_loreng.disabled = true
	button_lele.disabled = true
	button_buaya.disabled = true

func _sudah_ditangkap(nama: String) -> bool:
	for item in Global.album_koleksi:
		if item["nama"] == nama:
			return true
	return false

func _tutup_album():
	get_tree().paused = false
	queue_free()

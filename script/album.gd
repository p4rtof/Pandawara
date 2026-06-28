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

# Map nama ikan -> button & texture
var daftar_ikan = []

func _ready():
	tutup_button.pressed.connect(_tutup_album)

	daftar_ikan = [
		{"nama": "Sapu-sapu Biasa",  "button": button_sapu2,        "texture": "res://asset/album_sapu2.png"},
		{"nama": "Mujair",           "button": button_mujair,        "texture": "res://asset/album_mujair.png"},
		{"nama": "Sapu-sapu Albino", "button": button_sapu2_albino,  "texture": "res://asset/album_sapu2albino.png"},
		{"nama": "Mas",              "button": button_mas,           "texture": "res://asset/album_mas.png"},
		{"nama": "Sapu-sapu Loreng", "button": button_sapu2_loreng,  "texture": "res://asset/album_sapu2loreng.png"},
		{"nama": "Lele",             "button": button_lele,          "texture": "res://asset/album_lele.png"},
		{"nama": "Buaya",            "button": button_buaya,         "texture": "res://asset/album_buaya.png"},
	]

	var group = ButtonGroup.new()
	for entry in daftar_ikan:
		entry["button"].button_group = group
		var tex_path = entry["texture"]
		entry["button"].pressed.connect(func(): card_ikan.texture = load(tex_path))

	# Semua lock dulu
	_set_semua_locked()

	# Buka tombol yang sudah ditangkap
	for entry in daftar_ikan:
		entry["button"].disabled = not _sudah_ditangkap(entry["nama"])

	# Otomatis tampilkan ikan pertama yang sudah ditangkap
	var pertama = _cari_pertama_ditangkap()
	if pertama != null:
		card_ikan.texture = load(pertama["texture"])
		pertama["button"].button_pressed = true
	else:
		card_ikan.texture = load("res://asset/album_locked.png")

func _set_semua_locked():
	for entry in daftar_ikan:
		entry["button"].disabled = true

func _sudah_ditangkap(nama: String) -> bool:
	for item in Global.album_koleksi:
		if item["nama"] == nama:
			return true
	return false

func _cari_pertama_ditangkap():
	for entry in daftar_ikan:
		if _sudah_ditangkap(entry["nama"]):
			return entry
	return null

func _tutup_album():
	get_tree().paused = false
	queue_free()

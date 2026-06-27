extends Control

@onready var jumlah_label = $JumlahLabel
@onready var tutup_button = $TutupButton
@onready var card_ikan = $CardIkan
@onready var button_sapu2 = $GridContainer/ButtonSapu2
@onready var button_mujair = $GridContainer/ButtonMujair
@onready var button_sapu2_albino = $GridContainer/ButtonSapu2Albino
@onready var button_mas = $GridContainer/ButtonMas

func _ready():
	tutup_button.pressed.connect(_tutup_album)
	button_sapu2.pressed.connect(_on_button_sapu2_pressed)
	button_mujair.pressed.connect(_on_button_mujair_pressed)
	button_sapu2_albino.pressed.connect(_on_button_sapu2_albino_pressed)
	button_mas.pressed.connect(_on_button_mas_pressed)
	
	var group = ButtonGroup.new()
	button_sapu2.button_group = group
	button_mujair.button_group = group
	button_sapu2_albino.button_group = group
	button_mas.button_group = group
	
	# Disable tombol yang belum ditangkap
	button_sapu2.disabled = not _sudah_ditangkap("Sapu-sapu Biasa")
	button_mujair.disabled = not _sudah_ditangkap("Mujair")
	button_sapu2_albino.disabled = not _sudah_ditangkap("Sapu-sapu Albino")
	button_mas.disabled = not _sudah_ditangkap("Mas")
	
	# Default card = locked kalau belum ada ikan sama sekali
	if Global.album_koleksi.is_empty():
		card_ikan.texture = load("res://asset/album_locked.png")

func _sudah_ditangkap(nama: String) -> bool:
	for item in Global.album_koleksi:
		if item["nama"] == nama:
			return true
	return false

func _on_button_sapu2_pressed() -> void:
	card_ikan.texture = load("res://asset/album_sapu2.png")

func _on_button_mujair_pressed() -> void:
	card_ikan.texture = load("res://asset/album_mujair.png")

func _on_button_sapu2_albino_pressed() -> void:
	card_ikan.texture = load("res://asset/album_sapu2albino.png")

func _on_button_mas_pressed() -> void:
	card_ikan.texture = load("res://asset/album_mas.png")

func _tutup_album():
	get_tree().paused = false
	queue_free()

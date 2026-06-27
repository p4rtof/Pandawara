extends Control

# Gambar transisi dikelompokkan per bioma yang BARU SELESAI
var gambar_transisi = {
	0: [  # selesai dari HULU → mau ke PERTENGAHAN
		"res://asset/story/transisi_hulu_1.png",
		"res://asset/story/transisi_hulu_2.png",
		"res://asset/story/transisi_hulu_3.png",
		"res://asset/story/transisi_hulu_4.png",
		"res://asset/story/transisi_hulu_5.png",
		"res://asset/story/transisi_hulu_6.png",
		"res://asset/story/transisi_hulu_7.png",
		"res://asset/story/transisi_hulu_8.png",
		"res://asset/story/transisi_hulu_9.png",
	],
	1: [  # selesai dari PERTENGAHAN → mau ke PERKOTAAN
		"res://asset/story/transisi_tengah_1.png",
		"res://asset/story/transisi_tengah_2.png",
	],
}

var gambar_sekarang = []
var index = 0

@onready var background = $Background
@onready var lanjut_button = $LanjutButton
@onready var kembali_button = $KembaliButton

func _ready():
	MusicManager.putar("res://asset/audio/sound.ogg")
	gambar_sekarang = gambar_transisi.get(Global.bioma_dipilih, [])
	lanjut_button.pressed.connect(_on_lanjut)
	kembali_button.pressed.connect(_on_kembali)
	_tampilkan(0)

func _tampilkan(i: int):
	background.texture = load(gambar_sekarang[i])
	kembali_button.visible = i > 0
	if i == gambar_sekarang.size() - 1:
		lanjut_button.text = "Lanjut Bertualang ▶"
	else:
		lanjut_button.text = "Lanjut ▶"

func _on_lanjut():
	index += 1
	if index >= gambar_sekarang.size():
		Global.buka_bioma_berikutnya()
		get_tree().change_scene_to_file("res://scene/pilih_bioma.tscn")
	else:
		_tampilkan(index)

func _on_kembali():
	if index > 0:
		index -= 1
		_tampilkan(index)

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			_on_lanjut()

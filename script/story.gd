extends Control

var dialog = [
	{"nama": "Narator", "teks": "Di sebuah sungai yang tercemar..."},
	{"nama": "Narator", "teks": "Ikan sapu-sapu mulai merajalela!"},
	{"nama": "Pak Budi", "teks": "Tolong tangkap ikan sapu-sapu itu!"},
	{"nama": "Narator", "teks": "Petualanganmu dimulai..."}
]

var index = 0

@onready var nama_label = $DialogBox/NamaLabel
@onready var teks_label = $DialogBox/TeksLabel

func _ready():
	tampilkan_dialog(0)

func tampilkan_dialog(i: int):
	nama_label.text = dialog[i]["nama"]
	teks_label.text = dialog[i]["teks"]

func _on_lanjut_button_pressed():
	index += 1
	if index >= dialog.size():
		# Story selesai, pindah ke game
		get_tree().change_scene_to_file("res://scenes/main.tscn")
	else:
		tampilkan_dialog(index)

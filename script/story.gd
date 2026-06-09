extends Control

var pilih_bioma_scene = preload("res://scene/pilih_bioma.tscn")

var gambar_story = [
	"res://asset/story/story1.png",
	"res://asset/story/story2.png",
	"res://asset/story/story3.png",
	"res://asset/story/story4.png",
	"res://asset/story/story5.png",
	"res://asset/story/story6.png",
	"res://asset/story/story7.png",
	"res://asset/story/story8.png",
	"res://asset/story/story9.png",
	"res://asset/story/story10.png",
	"res://asset/story/story11.png",
	"res://asset/story/story12.png",
]

var index = 0

@onready var background = $Background
@onready var lanjut_button = $LanjutButton
@onready var kembali_button = $KembaliButton  # ← TAMBAH INI

func _ready():
	MusicManager.putar("res://asset/audio/sound.ogg")
	lanjut_button.pressed.connect(_on_lanjut)
	kembali_button.pressed.connect(_on_kembali)  # ← TAMBAH INI
	_tampilkan(0)

func _tampilkan(i: int):
	background.texture = load(gambar_story[i])
	
	
	# Sembunyikan tombol kembali di halaman pertama
	kembali_button.visible = i > 0  # ← TAMBAH INI
	
	if i == gambar_story.size() - 1:
		lanjut_button.text = "Mulai! ▶"
	else:
		lanjut_button.text = "Lanjut ▶"

func _on_lanjut():
	index += 1
	if index >= gambar_story.size():
		get_tree().change_scene_to_packed(pilih_bioma_scene)
	else:
		_tampilkan(index)

func _on_kembali():  # ← TAMBAH INI
	if index > 0:
		index -= 1
		_tampilkan(index)
		

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			_on_lanjut()

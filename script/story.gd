extends Control

var pilih_bioma_scene = preload("res://scene/pilih_bioma.tscn")

var gambar_story = [
	"res://asset/story/story1.png",
	"res://asset/story/story2.jpeg",
	"res://asset/story/story3.png",
	"res://asset/story/story4.png",
	"res://asset/story/story5.png",
	"res://asset/story/story6.png",
	"res://asset/story/story7.png",
	"res://asset/story/story8.png",
	"res://asset/story/story9.png",
]

var index = 0

@onready var background = $Background
@onready var lanjut_button = $LanjutButton
@onready var progress_label = $ProgressLabel

func _ready():
	lanjut_button.pressed.connect(_on_lanjut)
	_tampilkan(0)

func _tampilkan(i: int):
	background.texture = load(gambar_story[i])
	progress_label.text = str(i + 1) + " / " + str(gambar_story.size())
	
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

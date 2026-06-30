extends Control

@onready var background = $Background
var index = 0

func _ready():
	MusicManager.putar("res://asset/audio/sound.ogg")
	_tampilkan(0)

func _tampilkan(i: int):
	background.texture = load(Global.story_gambar[i])

func _on_lanjut():
	index += 1
	if index >= Global.story_gambar.size():
		_selesai()
	else:
		_tampilkan(index)

func _selesai():
	match Global.story_tujuan:
		Global.StoryTujuan.PILIH_BIOMA:
			get_tree().change_scene_to_file("res://scene/pilih_bioma.tscn")
		Global.StoryTujuan.MAIN_BIOMA:
			get_tree().change_scene_to_file("res://scene/game_sungai.tscn")
		Global.StoryTujuan.GAME_SELESAI:
			MusicManager.stop()  # hentikan musik dulu sebelum ke main menu
			get_tree().change_scene_to_file("res://scene/mainmenu.tscn")

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			_on_lanjut()

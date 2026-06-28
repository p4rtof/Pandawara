extends Control

@onready var background = $Background
#@onready var lanjut_button = $LanjutButton
#@onready var kembali_button = $KembaliButton

var index = 0

func _ready():
	MusicManager.putar("res://asset/audio/sound.ogg")
	#lanjut_button.pressed.connect(_on_lanjut)
	#kembali_button.pressed.connect(_on_kembali)
	_tampilkan(0)

func _tampilkan(i: int):
	background.texture = load(Global.story_gambar[i])
	#kembali_button.visible = i > 0

func _on_lanjut():
	index += 1
	if index >= Global.story_gambar.size():
		_selesai()
	else:
		_tampilkan(index)

func _on_kembali():
	if index > 0:
		index -= 1
		_tampilkan(index)

func _selesai():
	match Global.story_tujuan:
		Global.StoryTujuan.PILIH_BIOMA:
			Global.buka_bioma_berikutnya()
			get_tree().change_scene_to_file("res://scene/pilih_bioma.tscn")
		Global.StoryTujuan.MAIN_BIOMA:
			get_tree().change_scene_to_file("res://scene/game_sungai.tscn")
		Global.StoryTujuan.GAME_SELESAI:
			get_tree().change_scene_to_file("res://scene/mainmenu.tscn")   # ← GANTI dari gameover.tscn
			
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			_on_lanjut()

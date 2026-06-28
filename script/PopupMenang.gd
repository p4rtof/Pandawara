extends Control

@onready var skor_label = $CardImage/SkorLabel
@onready var target_label = $CardImage/TargetLabel
@onready var lanjut_button = $CardImage/LanjutButton
@onready var menu_button = $CardImage/MenuButton

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	skor_label.text = str(Global.poin)
	target_label.text = "%d/%d" % [Global.sapu_sapu_ditangkap, Global.target_sapu_sapu]
	MusicManager.putar_sfx("res://asset/audio/sfx_menang.ogg")
	MusicManager.kecilkan_musik()
	Global.buka_bioma_berikutnya()
	lanjut_button.pressed.connect(_on_lanjut)
	menu_button.pressed.connect(_on_menu)

func _on_lanjut():
	get_tree().paused = false
	MusicManager.kembalikan_musik()
	Global.siapkan_story_outro()
	get_tree().change_scene_to_file("res://scene/story_transisi.tscn")

func _on_menu():
	get_tree().paused = false
	MusicManager.kembalikan_musik()
	get_tree().change_scene_to_file("res://scene/pilih_bioma.tscn")

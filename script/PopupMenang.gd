extends Control

@onready var skor_label = $CardImage/SkorLabel
@onready var target_label = $CardImage/TargetLabel
@onready var lanjut_button = $CardImage/LanjutButton
@onready var menu_button = $CardImage/MenuButton

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	skor_label.text = str(Global.poin)
	target_label.text = "%d/%d" % [Global.sapu_sapu_ditangkap, Global.target_sapu_sapu]

	lanjut_button.pressed.connect(_on_lanjut)
	menu_button.pressed.connect(_on_menu)

func _on_lanjut():
	get_tree().paused = false
	if Global.bioma_dipilih < 2:
		get_tree().change_scene_to_file("res://scene/story_transisi.tscn")
	else:
		get_tree().change_scene_to_file("res://scene/gameover.tscn")  # bioma terakhir, ini "menang total"

func _on_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/mainmenu.tscn")

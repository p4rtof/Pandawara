extends Control

@onready var score_label = $CardImage/ScoreLabel
@onready var target_label = $CardImage/TargetLabel
@onready var menu_button = $CardImage/MenuButton
@onready var ulangi_button = $CardImage/UlangiButton

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	score_label.text = str(Global.poin)
	target_label.text = "%d/%d" % [Global.sapu_sapu_ditangkap, Global.target_sapu_sapu]
	menu_button.pressed.connect(_on_menu)
	ulangi_button.pressed.connect(_on_ulangi)

func _on_ulangi():
	get_tree().paused = false
	Global.poin = 0
	Global.nyawa = 5
	Global.album_koleksi.clear()
	Global.sapu_sapu_ditangkap = 0
	Global.sedang_game_over = false
	Global.target_sapu_sapu = Global.target_sapu_sapu_per_bioma[Global.bioma_dipilih]
	get_tree().change_scene_to_file("res://scene/game_sungai.tscn")

func _on_menu():
	get_tree().paused = false
	Global.poin = 0
	Global.nyawa = 5
	Global.album_koleksi.clear()
	Global.sapu_sapu_ditangkap = 0
	Global.sedang_game_over = false
	get_tree().change_scene_to_file("res://scene/mainmenu.tscn")

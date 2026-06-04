extends Control

@onready var score_label = $ScoreLabel
@onready var restart_button = $RestartButton

func _ready():
	# Tampilkan skor akhir
	score_label.text = "Skor Akhir: " + str(Global.poin)
	
	# Sambung tombol restart
	restart_button.pressed.connect(_on_restart_pressed)

func _on_restart_pressed():
	# Reset semua data
	Global.poin = 0
	Global.nyawa = 3
	Global.album_koleksi.clear()
	
	# Balik ke game
	get_tree().change_scene_to_file("res://scene/game.tscn")

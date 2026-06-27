extends Control

@onready var score_label = $ScoreLabel
@onready var restart_button = $RestartButton

func _ready():
	score_label.text = "Skor Akhir: " + str(Global.poin)
	restart_button.pressed.connect(_on_restart_pressed)

func _on_restart_pressed():
	# Reset progress di bioma yang sedang dimainkan
	Global.poin = 0
	Global.nyawa = 5
	Global.album_koleksi.clear()
	Global.sapu_sapu_ditangkap = 0          # ← INI YANG KURANG
	Global.sedang_game_over = false         # ← biar ikan.gd bisa proses ulang
	Global.target_sapu_sapu = Global.target_sapu_sapu_per_bioma[Global.bioma_dipilih]  # ← jaga2 kalau target per bioma beda

	# Balik ke bioma yang sama (Global.bioma_dipilih TIDAK direset, jadi tetap di bioma yang sama)
	get_tree().change_scene_to_file("res://scene/game_sungai.tscn")

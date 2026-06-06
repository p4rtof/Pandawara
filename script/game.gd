extends Node2D

@export var ikan_scene: PackedScene       # ikan biasa
@export var sapu_sapu_scene: PackedScene  # ikan sapu-sapu
var batas_ikan = 10

func _ready():
	MusicManager.putar("res://asset/audio/sound.ogg")
	$Timer.wait_time = 2.0
	$Timer.autostart = true
	$Timer.start()
	
	# Scroll ke bioma yang dipilih
	_pindah_ke_bioma(Global.bioma_dipilih)

func _pindah_ke_bioma(index: int):
	# Pindah kamera/player ke posisi bioma
	var target_y = index * 1080  # sesuaikan tinggi bioma
	$Player.position.y = target_y

func _on_timer_timeout():
	var ikan_sekarang = get_tree().get_nodes_in_group("ikan")
	if ikan_sekarang.size() >= batas_ikan:
		return
	
	var ikan_baru
	if randf() < 0.3:
		ikan_baru = sapu_sapu_scene.instantiate()
	else:
		ikan_baru = ikan_scene.instantiate()
	
	add_child(ikan_baru)
	
	# Spawn dari ATAS layar, x random di area air
	ikan_baru.position = Vector2(
		randf_range(-200, 200),  # random kiri-kanan di area air
		-400                      # selalu dari atas
	)

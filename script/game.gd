extends Node2D

@export var ikan_scene: PackedScene       # ikan biasa
@export var sapu_sapu_scene: PackedScene  # ikan sapu-sapu
var batas_ikan = 10

func _ready():
	$Timer.wait_time = 2.0
	$Timer.autostart = true
	$Timer.start()

func _on_timer_timeout():
	var ikan_sekarang = get_tree().get_nodes_in_group("ikan")
	if ikan_sekarang.size() >= batas_ikan:
		return
	
	# 30% chance spawn sapu-sapu, 70% ikan biasa
	var ikan_baru
	var angka_random = randf()
	if angka_random < 0.7:
		ikan_baru = sapu_sapu_scene.instantiate()
	else:
		ikan_baru = ikan_scene.instantiate()
	
	add_child(ikan_baru)
	ikan_baru.position = Vector2(
		randf_range(-400, 400),
		randf_range(-200, 200)
	)

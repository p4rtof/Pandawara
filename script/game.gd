extends Node2D

@export var ikan_scene: PackedScene
@export var sapu_sapu_scene: PackedScene
var batas_ikan = 50
var bg_tiles = []

func _ready():
	MusicManager.putar("res://asset/audio/sound.ogg")
	$Timer.wait_time = 2.0
	$Timer.start()
	
	# Player mulai di tengah
	$Player.position = Vector2(576, 0)
	
	# Reset kamera
	var cam = $Player.get_node("Camera2D")
	cam.offset = Vector2.ZERO
	cam.anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
	cam.position = Vector2.ZERO
	cam.reset_smoothing()
	cam.limit_left   = -200
	cam.limit_right  = 1350
	cam.limit_top    = -999999
	cam.limit_bottom = 999999
	cam.force_update_scroll()
	
	# Buat tile background
	var tex = load("res://asset/bg_sungai.png")
	var tex_h = tex.get_height() - 1
	for i in range(-10, 10):
		var spr = Sprite2D.new()
		spr.texture = tex
		spr.centered = false
		spr.position = Vector2(-200, i * tex_h)
		add_child(spr)
		move_child(spr, 0)
		bg_tiles.append(spr)
	
	# Spawn ikan awal di seluruh sungai
	_spawn_ikan_awal()

func _process(_delta):
	# Background tile ikut player
	if bg_tiles.size() == 0:
		return
	var tex_h = bg_tiles[0].texture.get_height() - 1
	var player_y = $Player.position.y
	for tile in bg_tiles:
		while tile.position.y > player_y + tex_h * 6:
			tile.position.y -= tex_h * bg_tiles.size()
		while tile.position.y < player_y - tex_h * 6:
			tile.position.y += tex_h * bg_tiles.size()

func _spawn_ikan_awal():
	for i in range(100):
		var ikan_baru
		if randf() < 0.3:
			ikan_baru = sapu_sapu_scene.instantiate()
		else:
			ikan_baru = ikan_scene.instantiate()
		
		ikan_baru.position = Vector2(
			randf_range(350, 1000),
			randf_range(-20000, 20000)  # seluruh sungai!
		)
		
		add_child(ikan_baru)
		ikan_baru.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(ikan_baru, "modulate:a", 1.0, 1.5)
		
func _on_timer_timeout():
	var ikan_sekarang = get_tree().get_nodes_in_group("ikan")
	if ikan_sekarang.size() >= batas_ikan:
		return
	
	var ikan_baru
	if randf() < 0.3:
		ikan_baru = sapu_sapu_scene.instantiate()
	else:
		ikan_baru = ikan_scene.instantiate()
	
	# Spawn di sekitar posisi player
	var player_pos = $Player.position
	var spawn_pos = Vector2.ZERO
	var jarak_aman = 200.0
	var max_coba = 20
	var coba = 0
	
	while coba < max_coba:
		spawn_pos = Vector2(
			randf_range(250, 900),
			player_pos.y + randf_range(-500, 500)
		)
		if spawn_pos.distance_to(player_pos) > jarak_aman:
			break
		coba += 1
	
	ikan_baru.position = spawn_pos
	add_child(ikan_baru)
	ikan_baru.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(ikan_baru, "modulate:a", 1.0, 1.5)

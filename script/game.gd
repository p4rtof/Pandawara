extends Node2D

@export var ikan_scene: PackedScene
@export var sapu_sapu_scene: PackedScene
var batas_ikan = 10
var bg_tiles = []

func _ready():
	MusicManager.putar("res://asset/audio/sound.ogg")
	$Timer.wait_time = 2.0
	$Timer.start()
	
	# Player mulai di tengah layar
	$Player.position = Vector2(576, 324)
	
	# Reset kamera ke tengah player
	var cam = $Player.get_node("Camera2D")
	cam.offset = Vector2.ZERO
	cam.anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
	cam.position = Vector2.ZERO
	cam.reset_smoothing()
	cam.limit_left   = -200
	cam.limit_right  = 1350
	cam.limit_top    = -999999
	cam.limit_bottom = 999999
	
	# Paksa kamera langsung ke posisi player
	cam.force_update_scroll()
	
	# Buat tile background
	var tex = load("res://asset/bg_sungai.png")
	var tex_h = tex.get_height()
	for i in range(-10, 10):
		var spr = Sprite2D.new()
		spr.texture = tex
		spr.centered = false
		spr.position = Vector2(-200, i * tex_h)
		add_child(spr)
		move_child(spr, 0)
		bg_tiles.append(spr)
		
func _process(_delta):
	# Tile background ikut player ke atas/bawah
	var tex_h = bg_tiles[0].texture.get_height()
	var player_y = $Player.position.y
	for i in range(bg_tiles.size()):
		var tile = bg_tiles[i]
		# Geser tile kalau terlalu jauh dari player
		while tile.position.y > player_y + tex_h * 6:
			tile.position.y -= tex_h * bg_tiles.size()
		while tile.position.y < player_y - tex_h * 6:
			tile.position.y += tex_h * bg_tiles.size()

func _on_timer_timeout():
	var ikan_sekarang = get_tree().get_nodes_in_group("ikan")
	if ikan_sekarang.size() >= batas_ikan:
		return
	
	var ikan_baru
	if randf() < 0.3:
		ikan_baru = sapu_sapu_scene.instantiate()
	else:
		ikan_baru = ikan_scene.instantiate()
	
	var player_pos = $Player.position
	var spawn_pos = Vector2.ZERO
	var jarak_aman = 250.0
	
	while true:
		spawn_pos = Vector2(
			randf_range(350, 850),
			player_pos.y + randf_range(-400, 400)
		)
		if spawn_pos.distance_to(player_pos) > jarak_aman:
			break
	
	ikan_baru.position = spawn_pos
	add_child(ikan_baru)
	ikan_baru.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(ikan_baru, "modulate:a", 1.0, 1.5)

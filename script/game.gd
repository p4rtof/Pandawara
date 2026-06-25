extends Node2D

@export var ikan_scene: PackedScene
@export var sapu_sapu_scene: PackedScene
var batas_ikan = 30

var sungai_atas = 0.0
var sungai_bawah = 0.0

func _ready():
	MusicManager.putar("res://asset/audio/sound.ogg")
	$Timer.wait_time = 2.0
	$Timer.start()
	
	# Buat background sungai — SATU gambar saja, TIDAK di-tile
	var tex = load("res://asset/bg_sungai.png")
	var target_width = 1552.0
	var bg_scale = target_width / tex.get_width()
	var tex_h_scaled = tex.get_height() * bg_scale
	
	var spr = Sprite2D.new()
	spr.texture = tex
	spr.centered = false
	spr.scale = Vector2(bg_scale, bg_scale)
	spr.position = Vector2(-200, 0)
	add_child(spr)
	move_child(spr, 0)
	
	sungai_atas = 0.0
	sungai_bawah = tex_h_scaled
	
	# Player mulai di dekat atas sungai
	$Player.position = Vector2(576, 80)
	
	# Kasih tahu player batas geraknya (atas & bawah)
	$Player.batas_atas = sungai_atas + 40
	$Player.batas_bawah = sungai_bawah - 40
	
	# Kamera dikunci sesuai ukuran sungai
	var cam = $Player.get_node("Camera2D")
	cam.offset = Vector2.ZERO
	cam.anchor_mode = Camera2D.ANCHOR_MODE_DRAG_CENTER
	cam.position = Vector2.ZERO
	cam.reset_smoothing()
	cam.limit_left   = -200
	cam.limit_right  = 1350
	cam.limit_top    = sungai_atas
	cam.limit_bottom = sungai_bawah
	cam.force_update_scroll()
	
	_spawn_ikan_awal()

func _spawn_ikan_awal():
	for i in range(25):
		var ikan_baru
		if randf() < 0.3:
			ikan_baru = sapu_sapu_scene.instantiate()
		else:
			ikan_baru = ikan_scene.instantiate()
		
		ikan_baru.position = Vector2(
			randf_range(350, 1000),  # ← disamakan dengan BATAS_KIRI/BATAS_KANAN player
			randf_range(sungai_atas + 100, sungai_bawah - 100)
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
	
	var player_pos = $Player.position
	var spawn_pos = Vector2.ZERO
	var jarak_aman = 200.0
	var max_coba = 20
	var coba = 0
	
	while coba < max_coba:
		spawn_pos = Vector2(
			randf_range(350, 1000),  # ← disamakan juga di sini
			clamp(player_pos.y + randf_range(-500, 500), sungai_atas + 100, sungai_bawah - 100)
		)
		if spawn_pos.distance_to(player_pos) > jarak_aman:
			break
		coba += 1
	
	ikan_baru.position = spawn_pos
	add_child(ikan_baru)
	ikan_baru.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(ikan_baru, "modulate:a", 1.0, 1.5)

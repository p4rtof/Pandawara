extends Node2D
@export var ikan_scene: PackedScene
@export var sapu_sapu_scene: PackedScene
@export var mas_scene: PackedScene
@export var mujair_scene: PackedScene
@export var sapu_sapu_albino_scene: PackedScene
@export var sapu_sapu_zebra_scene: PackedScene  # kota: +30 poin
@export var lele_scene: PackedScene             # kota: hati --
@export var buaya_scene: PackedScene            # kota: hati -3 saat mendekat

var batas_ikan = 30
var sungai_atas = 0.0
var sungai_bawah = 0.0

var bg_per_bioma = [
	"res://asset/bg_sungai.png",
	"res://asset/bg_tengah.png",
	"res://asset/bg_kota.png"
]

func _ready():
	MusicManager.putar("res://asset/audio/sound.ogg")
	$Timer.wait_time = 2.0
	$Timer.start()

	if Global.target_sapu_sapu_per_bioma.size() > Global.bioma_dipilih:
		Global.target_sapu_sapu = Global.target_sapu_sapu_per_bioma[Global.bioma_dipilih]

	var bg_path = bg_per_bioma[Global.bioma_dipilih]
	var tex = load(bg_path)
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

	$Player.position = Vector2(576, 80)
	$Player.batas_atas = sungai_atas + 40
	$Player.batas_bawah = sungai_bawah - 40

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

# --- KOLAM IKAN PER BIOMA ---
# format: { scene: PackedScene, bobot: float } -> bobot = peluang relatif muncul
func _kolam_ikan() -> Array:
	match Global.bioma_dipilih:
		0:  # DESA — sapu-sapu : mujair = 2:3
			return [
				{"scene": sapu_sapu_scene, "bobot": 2.0},
				{"scene": mujair_scene,    "bobot": 3.0},
			]
		1:  # PERTENGAHAN — albino : sapu-sapu : mas : mujair = 2:3:3:2
			return [
				{"scene": sapu_sapu_albino_scene, "bobot": 2.0},
				{"scene": sapu_sapu_scene,        "bobot": 3.0},
				{"scene": mas_scene,              "bobot": 3.0},
				{"scene": mujair_scene,           "bobot": 2.0},
			]
		_:  # PERKOTAAN — zebra:albino:sapu-sapu:lele:buaya = 1:2:3:3:1, mujair & mas lebih dikit dari buaya
			return [
				{"scene": sapu_sapu_zebra_scene,  "bobot": 1.0},
				{"scene": sapu_sapu_albino_scene, "bobot": 2.0},
				{"scene": sapu_sapu_scene,        "bobot": 3.0},
				{"scene": lele_scene,             "bobot": 3.0},
				{"scene": buaya_scene,            "bobot": 0.7},
				{"scene": mujair_scene,           "bobot": 0.5},
				{"scene": mas_scene,              "bobot": 0.5},
			]

func _ambil_ikan_acak() -> Node:
	var kolam = _kolam_ikan()

	# Buang entry yang scene-nya belum diassign di Inspector
	var kolam_valid: Array = []
	for item in kolam:
		if item["scene"] != null:
			kolam_valid.append(item)
		else:
			push_warning("scene null di kolam bioma %d, dilewati." % Global.bioma_dipilih)

	if kolam_valid.is_empty():
		push_error("Tidak ada scene ikan valid di bioma %d!" % Global.bioma_dipilih)
		return null

	var total_bobot = 0.0
	for item in kolam_valid:
		total_bobot += item["bobot"]

	var pilihan = randf() * total_bobot
	var kumulatif = 0.0
	for item in kolam_valid:
		kumulatif += item["bobot"]
		if pilihan <= kumulatif:
			return item["scene"].instantiate()

	return kolam_valid[0]["scene"].instantiate()  # fallback

func _spawn_ikan_awal():
	for i in range(25):
		var ikan_baru = _ambil_ikan_acak()
		if ikan_baru == null:
			continue

		ikan_baru.position = Vector2(
			randf_range(350, 1000),
			randf_range(sungai_atas + 100, sungai_bawah - 100)
		)
		ikan_baru.modulate.a = 0.0
		ikan_baru.scale *= 0.5

		add_child(ikan_baru)

		var target_scale = ikan_baru.scale * 2.0
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(ikan_baru, "modulate:a", 1.0, 1.5)
		tween.tween_property(ikan_baru, "scale", target_scale, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_timer_timeout():
	var ikan_sekarang = get_tree().get_nodes_in_group("ikan")
	if ikan_sekarang.size() >= batas_ikan:
		return

	var ikan_baru = _ambil_ikan_acak()
	if ikan_baru == null:
		return

	var player_pos = $Player.position
	var spawn_pos = Vector2.ZERO
	var jarak_aman = 200.0
	var max_coba = 20
	var coba = 0

	while coba < max_coba:
		spawn_pos = Vector2(
			randf_range(350, 1000),
			clamp(player_pos.y + randf_range(-500, 500), sungai_atas + 100, sungai_bawah - 100)
		)
		if spawn_pos.distance_to(player_pos) > jarak_aman:
			break
		coba += 1

	ikan_baru.position = spawn_pos
	ikan_baru.modulate.a = 0.0
	ikan_baru.scale *= 0.5

	add_child(ikan_baru)

	var target_scale = ikan_baru.scale * 2.0
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(ikan_baru, "modulate:a", 1.0, 1.5)
	tween.tween_property(ikan_baru, "scale", target_scale, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

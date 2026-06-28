extends Area2D
@export var nama_ikan: String = "Ikan Biasa"
@export var deskripsi: String = "Ikan sungai biasa"
@export var adalah_sapu_sapu: bool = false
@export var poin_tangkap: int = 10
@export var texture_ikan: Texture2D
@export var kelangkaan: String = "Umum" 
@export var texture_popup: Texture2D 
@export var damage_nyawa: int = 1
var arah = Vector2.ZERO
var kecepatan = 0.0
var timer_ganti_arah = 0.0
var sedang_ditekan = false
var timer_tekan = 0.0
const LAMA_TEKAN = 0.8
var popup_scene = preload("res://scene/popup_ikan.tscn")
var popup_menang_scene = preload("res://scene/PopupMenang.tscn")

func _ready():
	$Sprite2D.texture = texture_ikan
	kecepatan = randf_range(80, 150)
	input_pickable = true
	area_entered.connect(_on_area_entered)
	arah = Vector2(randf_range(-0.3, 0.3), 1).normalized()
	$Sprite2D.flip_h = arah.x < 0
	timer_ganti_arah = randf_range(2.0, 4.0)

func _process(delta):
	position += arah * kecepatan * delta
	timer_ganti_arah -= delta
	if timer_ganti_arah <= 0:
		_ganti_arah()
	if position.x > 1000:
		position.x = 1000
		_ganti_arah()
	elif position.x < 350:
		position.x = 350
		_ganti_arah()
	if sedang_ditekan:
		timer_tekan += delta
		if timer_tekan >= LAMA_TEKAN:
			sedang_ditekan = false
			timer_tekan = 0.0
			_tambah_ke_album()

func _ganti_arah():
	var sudut = randf_range(0, TAU)
	arah = Vector2(cos(sudut), sin(sudut))
	$Sprite2D.flip_h = arah.x < 0
	timer_ganti_arah = randf_range(2.0, 4.0)

func _cek_dan_tambah_album(data: Dictionary) -> bool:
	# Cek di semua bioma dulu — kalau sudah pernah ditangkap di manapun, skip
	for bioma in Global.album_per_bioma:
		for item in bioma:
			if item["nama"] == data["nama"]:
				return false
	# Simpan ke bioma yang sedang dimainkan
	Global.album_per_bioma[Global.bioma_dipilih].append(data)
	return true

func _tampilkan_popup(data: Dictionary):
	var ui = get_tree().get_first_node_in_group("ui_layer")
	if ui == null:
		ui = get_tree().current_scene
	var popup = popup_scene.instantiate()
	ui.add_child(popup)
	popup.tampilkan(data)

func _tampilkan_popup_menang():
	get_tree().paused = true
	var ui = get_tree().get_first_node_in_group("ui_layer")
	if ui == null:
		ui = get_tree().current_scene
	var popup = popup_menang_scene.instantiate()
	ui.add_child(popup)

func _on_area_entered(_area: Area2D) -> void:
	if _area.is_in_group("jaring"):
		MusicManager.putar_sfx("res://asset/audio/sfx_tangkap.ogg")
		var data = _get_data()
		var adalah_baru = _cek_dan_tambah_album(data)
		if adalah_baru:
			_tampilkan_popup(data)
		if Global.sedang_game_over:
			call_deferred("queue_free")
			return
		if adalah_sapu_sapu:
			Global.poin += poin_tangkap
			Global.poin_per_bioma[Global.bioma_dipilih] += poin_tangkap
			Global.sapu_sapu_ditangkap += 1
			print("✅ Sapu-sapu %d/%d | +%d poin | Total: %d" % [
				Global.sapu_sapu_ditangkap,
				Global.target_sapu_sapu,
				poin_tangkap,
				Global.poin
			])
			if Global.sapu_sapu_ditangkap >= Global.target_sapu_sapu and not Global.sedang_game_over:
				Global.sedang_game_over = true
				call_deferred("_tampilkan_popup_menang")
				return
		else:
			var kurang = damage_nyawa
			if Global.nyawa > 0:
				Global.nyawa -= kurang
				if Global.nyawa < 0:
					Global.nyawa = 0
				print("❌ %s mengurangi %d hati | Nyawa: %d" % [nama_ikan, kurang, Global.nyawa])
			if Global.nyawa <= 0 and not Global.sedang_game_over:
				Global.sedang_game_over = true
				call_deferred("_tampilkan_gameover")
				return
		call_deferred("queue_free")

func _tampilkan_gameover():
	var ui = get_tree().get_first_node_in_group("ui_layer")
	if ui == null:
		ui = get_tree().current_scene
	var gameover_scene = load("res://scene/gameover.tscn")
	var gameover = gameover_scene.instantiate()
	ui.add_child(gameover)

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				sedang_ditekan = true
				timer_tekan = 0.0
			else:
				sedang_ditekan = false
				timer_tekan = 0.0

func _tambah_ke_album():
	var data = _get_data()
	var adalah_baru = _cek_dan_tambah_album(data)
	if adalah_baru:
		_tampilkan_popup(data)
		print("📖 Ditambah ke album: ", nama_ikan)
	else:
		print("📖 Sudah ada di album: ", nama_ikan)

func _get_data() -> Dictionary:
	return {
		"nama": nama_ikan,
		"deskripsi": deskripsi,
		"adalah_sapu_sapu": adalah_sapu_sapu,
		"texture": texture_ikan,
		"texture_popup": texture_popup,
		"kelangkaan": kelangkaan
	}

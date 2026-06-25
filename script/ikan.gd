extends Area2D

@export var nama_ikan: String = "Ikan Biasa"
@export var deskripsi: String = "Ikan sungai biasa"
@export var adalah_sapu_sapu: bool = false
@export var poin_tangkap: int = 10
@export var texture_ikan: Texture2D
@export var kelangkaan: String = "Umum" 

var arah = Vector2.ZERO
var kecepatan = 0.0
var timer_ganti_arah = 0.0
var sedang_ditekan = false
var timer_tekan = 0.0
const LAMA_TEKAN = 0.8

var popup_scene = preload("res://scene/popup_ikan.tscn")

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
	# Return true kalau ikan BARU (belum ada di album)
	for item in Global.album_koleksi:
		if item["nama"] == data["nama"]:
			return false  # sudah ada
	Global.album_koleksi.append(data)
	return true  # baru!

func _tampilkan_popup(data: Dictionary):
	# Tampilkan popup di atas UI
	var ui = get_tree().get_first_node_in_group("ui_layer")
	if ui == null:
		# Fallback: cari CanvasLayer
		ui = get_tree().current_scene
	var popup = popup_scene.instantiate()
	ui.add_child(popup)
	popup.tampilkan(data)

func _on_area_entered(_area: Area2D) -> void:
	if _area.is_in_group("jaring"):
		var data = _get_data()
		var adalah_baru = _cek_dan_tambah_album(data)
		
		# Kalau ikan baru → tampilkan popup!
		if adalah_baru:
			_tampilkan_popup(data)
		
		if adalah_sapu_sapu:
			Global.poin += poin_tangkap
			Global.poin_per_bioma[Global.bioma_dipilih] += poin_tangkap
			print("✅ Poin: +", poin_tangkap, " Total: ", Global.poin)
		else:
			if Global.nyawa > 0:
				Global.nyawa -= 1
				print("❌ Nyawa: ", Global.nyawa)
			if Global.nyawa <= 0:
				get_tree().call_deferred("change_scene_to_file", "res://scene/gameover.tscn")
				return
		call_deferred("queue_free")

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
		"kelangkaan": kelangkaan 
	}

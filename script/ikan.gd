extends Area2D

@export var nama_ikan: String = "Ikan Biasa"
@export var deskripsi: String = "Ikan sungai biasa"
@export var adalah_sapu_sapu: bool = false
@export var texture_ikan: Texture2D

var arah = Vector2.ZERO
var kecepatan = 0.0
var timer_ganti_arah = 0.0

# Long press
var sedang_ditekan = false
var timer_tekan = 0.0
const LAMA_TEKAN = 0.8  # sekian detik = long press

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
	
	# Batas area air X (Kiri - Kanan)
	if position.x > 1150:
		position.x = 1150
		_ganti_arah()
	elif position.x < 350:
		position.x = 350
		_ganti_arah()
		
	# Batas area air Y (Atas - Bawah)
	if position.y > 950:
		position.y = 950
		_ganti_arah()
	elif position.y < 50:
		position.y = 50
		_ganti_arah()
	
	# Hitung durasi tekan
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

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Mulai hitung tekan
				sedang_ditekan = true
				timer_tekan = 0.0
			else:
				# Dilepas sebelum long press
				sedang_ditekan = false
				timer_tekan = 0.0

func _tambah_ke_album():
	var data = _get_data()
	var sudah_ada = false
	for item in Global.album_koleksi:
		if item["nama"] == data["nama"]:
			sudah_ada = true
	if not sudah_ada:
		Global.album_koleksi.append(data)
		print("📖 Ditambah ke album: ", nama_ikan)
	else:
		print("📖 Sudah ada di album: ", nama_ikan)

func _on_area_entered(_area: Area2D) -> void:
	if _area.is_in_group("jaring"):
		var data = _get_data()
		var sudah_ada = false
		for item in Global.album_koleksi:
			if item["nama"] == data["nama"]:
				sudah_ada = true
		if not sudah_ada:
			Global.album_koleksi.append(data)
		
		if adalah_sapu_sapu:
			Global.poin += 10
			print("✅ Poin: ", Global.poin)
		else:
			if Global.nyawa > 0:
				Global.nyawa -= 1
				print("❌ Nyawa: ", Global.nyawa)
			if Global.nyawa <= 0:
				get_tree().call_deferred("change_scene_to_file", "res://scene/gameover.tscn")
				return
		call_deferred("queue_free")

func _get_data() -> Dictionary:
	return {
		"nama": nama_ikan,
		"deskripsi": deskripsi,
		"adalah_sapu_sapu": adalah_sapu_sapu,
		"texture": texture_ikan  # ← simpan texture juga!
	}

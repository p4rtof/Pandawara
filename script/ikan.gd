extends Area2D

@export var nama_ikan: String = "Ikan Sapu-Sapu"
@export var deskripsi: String = "Ikan pembersih dasar sungai"
@export var adalah_sapu_sapu: bool = false
@export var texture_ikan: Texture2D

signal ikan_diklik(data_ikan)

var arah = Vector2.ZERO
var kecepatan = 0.0
var timer_ganti_arah = 0.0

func _ready():
	$Sprite2D.texture = texture_ikan
	kecepatan = randf_range(80, 150)
	input_pickable = true
	area_entered.connect(_on_area_entered)
	_ganti_arah() # Set arah awal random

func _process(delta):
	# Gerak sesuai arah
	position += arah * kecepatan * delta
	
	# Timer ganti arah tiap 2-4 detik
	timer_ganti_arah -= delta
	if timer_ganti_arah <= 0:
		_ganti_arah()
	
	# Batas area berenang (biar gak kabur jauh)
	if position.x > 800:
		position.x = 800
		_ganti_arah()
	elif position.x < -800:
		position.x = -800
		_ganti_arah()
	if position.y > 400:
		position.y = 400
		_ganti_arah()
	elif position.y < -400:
		position.y = -400
		_ganti_arah()

func _ganti_arah():
	# Pilih arah random (atas, bawah, kiri, kanan, diagonal)
	var sudut = randf_range(0, TAU) # TAU = 360 derajat
	arah = Vector2(cos(sudut), sin(sudut))
	
	# Flip sprite sesuai arah horizontal
	$Sprite2D.flip_h = arah.x < 0
	
	# Set timer ganti arah berikutnya (2-4 detik)
	timer_ganti_arah = randf_range(2.0, 4.0)

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
			Global.nyawa -= 1
			print("❌ Nyawa: ", Global.nyawa)
			if Global.nyawa <= 0:
				get_tree().change_scene_to_file("res://scene/gameover.tscn")
		queue_free()

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		var data = _get_data()
		var sudah_ada = false
		for item in Global.album_koleksi:
			if item["nama"] == data["nama"]:
				sudah_ada = true
		if not sudah_ada:
			Global.album_koleksi.append(data)
		print("📖 Diklik: ", nama_ikan)

func _get_data() -> Dictionary:
	return {
		"nama": nama_ikan,
		"deskripsi": deskripsi,
		"adalah_sapu_sapu": adalah_sapu_sapu
	}

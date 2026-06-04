extends Area2D

@export var nama_ikan: String = "Ikan Biasa"
@export var deskripsi: String = "Ikan sungai biasa"
@export var adalah_sapu_sapu: bool = false
@export var texture_ikan: Texture2D

var arah = Vector2.ZERO
var kecepatan = 0.0
var timer_ganti_arah = 0.0



func _process(delta):
	position += arah * kecepatan * delta
	
	timer_ganti_arah -= delta
	if timer_ganti_arah <= 0:
		_ganti_arah()
	
	# Batas area air
	if position.x > 200:
		position.x = 200
		_ganti_arah()
	elif position.x < -200:
		position.x = -200
		_ganti_arah()
	if position.y > 300:
		position.y = 300
		_ganti_arah()
	elif position.y < -300:
		position.y = -300
		_ganti_arah()

func _ready():
	$Sprite2D.texture = texture_ikan
	kecepatan = randf_range(80, 150)
	input_pickable = true
	area_entered.connect(_on_area_entered)
	# Arah awal ke bawah biar keliatan masuk dari atas
	arah = Vector2(randf_range(-0.3, 0.3), 1).normalized()
	$Sprite2D.flip_h = arah.x < 0
	timer_ganti_arah = randf_range(2.0, 4.0)

func _ganti_arah():
	# Setelah masuk, gerak bebas random
	var sudut = randf_range(0, TAU)
	arah = Vector2(cos(sudut), sin(sudut))
	$Sprite2D.flip_h = arah.x < 0
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
			if Global.nyawa > 0:
				Global.nyawa -= 1
				print("❌ Nyawa: ", Global.nyawa)
			if Global.nyawa <= 0:
				# Pakai call_deferred biar aman!
				get_tree().call_deferred("change_scene_to_file", "res://scene/gameover.tscn")
				return
		
		# Pakai call_deferred bukan queue_free langsung!
		call_deferred("queue_free")
		
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

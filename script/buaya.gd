extends Area2D

@export var nama_ikan: String = "Buaya"
@export var deskripsi: String = "Reptil berbahaya yang menghuni sungai kota"
@export var texture_ikan: Texture2D
@export var kelangkaan: String = "Langka"
@export var texture_popup: Texture2D

const DAMAGE_NYAWA: int = 3
const COOLDOWN_DAMAGE: float = 2.0

var arah = Vector2.ZERO
var kecepatan = 0.0
var timer_ganti_arah = 0.0
var timer_cooldown_damage = 0.0

var popup_scene = preload("res://scene/popup_ikan.tscn")

func _ready():
	$Sprite2D.texture = texture_ikan
	kecepatan = randf_range(50, 100)
	input_pickable = false
	arah = Vector2(randf_range(-0.3, 0.3), 1).normalized()
	$Sprite2D.flip_h = arah.x < 0
	timer_ganti_arah = randf_range(2.0, 4.0)
	# Deteksi Area2D (jaring) dan CharacterBody2D (player langsung)
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

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
	if timer_cooldown_damage > 0:
		timer_cooldown_damage -= delta

# Kena CharacterBody2D (Player langsung)
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_serang_pemain()

# Kena Area2D (Jaring)
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("jaring"):
		_serang_pemain()

func _serang_pemain():
	if Global.sedang_game_over:
		return
	if timer_cooldown_damage > 0:
		return
	timer_cooldown_damage = COOLDOWN_DAMAGE

	# Kurangi nyawa -3
	Global.nyawa -= DAMAGE_NYAWA
	if Global.nyawa < 0:
		Global.nyawa = 0
	print("🐊 Buaya menyerang! -3 hati | Nyawa: %d" % Global.nyawa)

	# Tampilkan popup buaya
	var data = _get_data()
	var adalah_baru = _cek_dan_tambah_album(data)
	if adalah_baru:
		_tampilkan_popup(data)

	if Global.nyawa <= 0 and not Global.sedang_game_over:
		Global.sedang_game_over = true
		call_deferred("_tampilkan_gameover")


func _tampilkan_gameover():
	var ui = get_tree().get_first_node_in_group("ui_layer")
	if ui == null:
		ui = get_tree().current_scene
	var gameover_scene = load("res://scene/gameover.tscn")
	var gameover = gameover_scene.instantiate()
	ui.add_child(gameover)

func _ganti_arah():
	var sudut = randf_range(0, TAU)
	arah = Vector2(cos(sudut), sin(sudut))
	$Sprite2D.flip_h = arah.x < 0
	timer_ganti_arah = randf_range(2.0, 4.0)

func _cek_dan_tambah_album(data: Dictionary) -> bool:
	for item in Global.album_koleksi:
		if item["nama"] == data["nama"]:
			return false
	Global.album_koleksi.append(data)
	return true

func _tampilkan_popup(data: Dictionary):
	var ui = get_tree().get_first_node_in_group("ui_layer")
	if ui == null:
		ui = get_tree().current_scene
	var popup = popup_scene.instantiate()
	ui.add_child(popup)
	popup.tampilkan(data)

func _get_data() -> Dictionary:
	return {
		"nama": nama_ikan,
		"deskripsi": deskripsi,
		"adalah_sapu_sapu": false,
		"texture": texture_ikan,
		"texture_popup": texture_popup,
		"kelangkaan": kelangkaan
	}

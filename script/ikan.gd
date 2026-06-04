extends Area2D

@export var nama_ikan: String = "Ikan Sapu-Sapu"
@export var deskripsi: String = "Ikan pembersih dasar sungai"
@export var adalah_sapu_sapu: bool = false
@export var texture_ikan: Texture2D

signal ikan_ditangkap(data_ikan)
signal ikan_diklik(data_ikan)

var arah = 1.0
var kecepatan = 0.0

func _ready():
	$Sprite2D.texture = texture_ikan
	kecepatan = randf_range(80, 150)
	arah = [-1, 1].pick_random()
	$Sprite2D.flip_h = arah < 0
	input_pickable = true
	# Sambung sinyal lewat kode (bukan editor)
	area_entered.connect(_on_area_entered)

func _process(delta):
	position.x += arah * kecepatan * delta
	if position.x > 500:
		arah = -1.0
		$Sprite2D.flip_h = true
	elif position.x < -500:
		arah = 1.0
		$Sprite2D.flip_h = false

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("ikan_diklik", _get_data())

func _get_data() -> Dictionary:
	return {
		"nama": nama_ikan,
		"deskripsi": deskripsi,
		"adalah_sapu_sapu": adalah_sapu_sapu
	}


func _on_area_entered(_area: Area2D) -> void:
	if _area.is_in_group("jaring"):
		if adalah_sapu_sapu:
			Global.poin += 10
			print("✅ Poin: ", Global.poin)
		else:
			Global.nyawa -= 1
			print("❌ Nyawa: ", Global.nyawa)
		queue_free()

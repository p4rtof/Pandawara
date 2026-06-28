extends CharacterBody2D

const SPEED = 300.0

@onready var jaring_kanan = $Jaring/JaringKanan
@onready var jaring_kiri = $Jaring/JaringKiri
@onready var sprite = $Sprite2D

const BATAS_KIRI = 350.0    # ← sesuaikan angka ini
const BATAS_KANAN = 1000.0  # ← sesuaikan angka ini

var batas_atas = -999999.0
var batas_bawah = 999999.0

func _ready():
	add_to_group("player") 
	jaring_kanan.disabled = true
	jaring_kiri.disabled = true

func _physics_process(_delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir * SPEED

	if input_dir.x > 0:
		sprite.flip_h = false
		jaring_kanan.disabled = false
		jaring_kiri.disabled = true
	elif input_dir.x < 0:
		sprite.flip_h = true
		jaring_kanan.disabled = true
		jaring_kiri.disabled = false

	move_and_slide()
	
	position.x = clamp(position.x, BATAS_KIRI, BATAS_KANAN)  # ← uncomment, player mentok kiri-kanan
	position.y = clamp(position.y, batas_atas, batas_bawah)

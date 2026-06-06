extends CharacterBody2D

const SPEED = 300.0

@onready var jaring_kanan = $Jaring/JaringKanan
@onready var jaring_kiri = $Jaring/JaringKiri
@onready var sprite = $Sprite2D

# ← SESUAIKAN angka ini dengan lebar sungai di gambarmu!
# PERHATIKAN! Karena posisi minus, kiri lebih kecil dari kanan
const BATAS_KIRI = -1300.0   # ← angka lebih kecil (kiri)
const BATAS_KANAN = -610.0  # ← angka lebih besar (kanan)

func _ready():
	jaring_kanan.disabled = true
	jaring_kiri.disabled = true

func _physics_process(_delta):
	#/print("X: ", position.x)
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
	else:
		jaring_kanan.disabled = true
		jaring_kiri.disabled = true

	move_and_slide()
	
	# Batasi posisi player di area sungai
	position.x = clamp(position.x, BATAS_KIRI, BATAS_KANAN)
	

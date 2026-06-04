extends CharacterBody2D

const SPEED = 300.0

@onready var jaring_kanan = $Jaring/JaringKanan
@onready var jaring_kiri = $Jaring/JaringKiri
@onready var sprite = $Sprite2D

func _ready() -> void:
	# Default: matiin dua-duanya dulu
	jaring_kanan.disabled = true
	jaring_kiri.disabled = true

func _physics_process(_delta: float) -> void:
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	velocity = input_dir * SPEED

	# Logika arah jaring
	if input_dir.x > 0: # Gerak ke kanan
		sprite.flip_h = false
		jaring_kanan.disabled = false
		jaring_kiri.disabled = true
	elif input_dir.x < 0: # Gerak ke kiri
		sprite.flip_h = true
		jaring_kanan.disabled = true
		jaring_kiri.disabled = false
	#else: # Diam / gerak atas-bawah
		#jaring_kanan.disabled = true
		#jaring_kiri.disabled = true

	move_and_slide()


func _on_timer_timeout() -> void:
	pass # Replace with function body.

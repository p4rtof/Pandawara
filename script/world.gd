extends Node2D

@onready var bioma_bersih = $BiomaBersih
@onready var bioma_tengah = $BiomaTengah  
@onready var bioma_bawah = $BiomaBawah

func _ready():
	# Susun bioma vertikal ke bawah
	bioma_bersih.position.y = 0
	bioma_tengah.position.y = 2000
	bioma_bawah.position.y = 4000
	
	# Fix semua TextureRect
	_fix_texturerect(bioma_bersih)
	_fix_texturerect(bioma_tengah)
	_fix_texturerect(bioma_bawah)

func _fix_texturerect(bioma: Node):
	for child in bioma.get_children():
		if child is TextureRect:
			child.position = Vector2(-576, -3000)
			child.size = Vector2(1152, 9000)
			child.stretch_mode = TextureRect.STRETCH_TILE

extends Control

# Gunakan @onready agar variabel langsung terisi saat node siap
@onready var dialog = $DialogBox
@onready var tombol_batal = $DialogBox/tombolBatal
@onready var tombol_keluar = $DialogBox/tombolKeluar

func _ready():
	print("popup ready")
	
	# Cek apakah node ditemukan sebelum connect sinyal
	if tombol_batal:
		tombol_batal.pressed.connect(_on_batal)
	else:
		print("Error: tombolBatal tidak ditemukan!")
		
	if tombol_keluar:
		tombol_keluar.pressed.connect(_on_keluar)
	else:
		print("Error: tombolKeluar tidak ditemukan!")

func _on_batal():
	print("batal ditekan")
	queue_free() # Menghapus popup dari scene

func _on_keluar():
	print("keluar ditekan")
	get_tree().quit() # Keluar dari game 

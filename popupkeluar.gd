extends Control

func _ready():
	print("popup ready")
	print($DialogBox/tombolBatal)
	print($DialogBox/tombolKeluar)
	$DialogBox/tombolBatal.pressed.connect(_on_batal)
	$DialogBox/tombolKeluar.pressed.connect(_on_keluar)

func _on_batal():
	print("batal ditekan")
	queue_free()

func _on_keluar():
	print("keluar ditekan")
	get_tree().quit()

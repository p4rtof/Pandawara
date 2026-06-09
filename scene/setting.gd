extends Control

func _ready():
	# Suara slider
	$Panel/SuaraSlider.value = AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("Master")
	)
	$Panel/SuaraSlider.value_changed.connect(_on_suara_changed)
	
	# Musik slider
	$Panel/MusikSlider.value = AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("Music")
	)
	$Panel/MusikSlider.value_changed.connect(_on_musik_changed)
	
	# Tombol kembali
	$BackButton.pressed.connect(_on_back)

func _on_suara_changed(value: float):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"), value
	)

func _on_musik_changed(value: float):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"), value
	)

func _on_back():
	get_tree().change_scene_to_file("res://scene/mainmenu.tscn")

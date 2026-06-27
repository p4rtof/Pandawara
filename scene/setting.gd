extends Control

func _ready():
	$BackButton.pressed.connect(_on_back)
	
	# Suara slider
	$SuaraSlider.min_value = -40
	$SuaraSlider.max_value = 0
	$SuaraSlider.value = AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("Master")
	)
	$SuaraSlider.value_changed.connect(_on_suara_changed)
	
	# Musik slider
	$MusikSlider.min_value = -40
	$MusikSlider.max_value = 0
	$MusikSlider.value = AudioServer.get_bus_volume_db(
		AudioServer.get_bus_index("Music")
	)
	$MusikSlider.value_changed.connect(_on_musik_changed)

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

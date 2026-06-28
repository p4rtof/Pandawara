extends Control

@onready var resume_button = $Pause/ResumeButton
@onready var main_menu_button = $Pause/MainMenuButton
@onready var tutorial_button = $Pause/TutorialButton

var tutorial_scene = preload("res://scene/tutorial_popup.tscn")

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	resume_button.pressed.connect(_resume)
	main_menu_button.pressed.connect(_ke_main_menu)
	tutorial_button.pressed.connect(_buka_tutorial)

	# Setup slider yang ada
	_setup_slider("SuaraSlider", "Master")
	_setup_slider("MusikSlider", "Music")

func _setup_slider(nama_node: String, nama_bus: String):
	var slider = get_node_or_null("Pause/" + nama_node)
	if slider == null:
		return  # skip kalau node belum dibuat
	var bus_idx = AudioServer.get_bus_index(nama_bus)
	if bus_idx == -1:
		return  # skip kalau bus tidak ada
	slider.min_value = -40
	slider.max_value = 0
	slider.value = AudioServer.get_bus_volume_db(bus_idx)
	slider.value_changed.connect(func(val): AudioServer.set_bus_volume_db(bus_idx, val))

func _resume():
	get_tree().paused = false
	queue_free()

func _ke_main_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/pilih_bioma.tscn")

func _buka_tutorial():
	var tutorial = tutorial_scene.instantiate()
	add_child(tutorial)

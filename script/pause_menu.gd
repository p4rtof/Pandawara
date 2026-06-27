extends Control

@onready var resume_button = $Pause/ResumeButton
@onready var main_menu_button = $Pause/MainMenuButton
@onready var tutorial_button = $Pause/TutorialButton

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS 
	resume_button.pressed.connect(_resume)
	main_menu_button.pressed.connect(_ke_main_menu)
	tutorial_button.pressed.connect(_buka_tutorial)

func _resume():
	get_tree().paused = false
	queue_free()

func _ke_main_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/mainmenu.tscn")

func _buka_tutorial():
	print("buka tutorial")  # g   anti sesuai kebutuhan nanti

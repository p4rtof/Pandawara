extends Control

@onready var tutup_button = $TutupButton

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	tutup_button.pressed.connect(_tutup)

func _tutup():
	queue_free()

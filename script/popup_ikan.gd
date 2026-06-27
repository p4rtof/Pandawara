extends Control

@onready var card_background = $CardBackground

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func tampilkan(data: Dictionary):
	if data.has("texture_popup") and data["texture_popup"] != null:
		card_background.texture = data["texture_popup"]

	set_anchors_preset(Control.PRESET_CENTER)

	get_tree().paused = true   # ← game pause selama popup muncul

	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.3)

func _input(event):
	if event.is_action_pressed("ui_select"):  # tombol SPACE
		_tutup()

func _tutup():
	get_tree().paused = false   # ← lanjut main lagi
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_callback(queue_free)

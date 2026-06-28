extends Control

@onready var card_background = $CardBackground

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	#MusicManager.putar_sfx("res://asset/audio/sfx_popup_ikan.ogg")
	#MusicManager.kecilkan_musik()

func tampilkan(data: Dictionary):
	if data.has("texture_popup") and data["texture_popup"] != null:
		card_background.texture = data["texture_popup"]

	set_anchors_preset(Control.PRESET_CENTER)

	get_tree().paused = true

	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.3)

func _input(event):
	if event.is_action_pressed("ui_select"):
		_tutup()

func _tutup():
	get_tree().paused = false
	MusicManager.kembalikan_musik()
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.2)
	tween.tween_callback(queue_free)

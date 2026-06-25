extends Control

var popup_keluar = preload("res://scene/PopupKeluar.tscn")

func _ready():
	MusicManager.putar("res://asset/audio/sound.ogg")
	$PlayButton.pressed.connect(_on_play)
	$SettingButton.pressed.connect(_on_setting)
	$ExitButton.pressed.connect(_on_keluar)
	
	$PlayButton.mouse_entered.connect(_on_hover.bind($PlayButton))
	$PlayButton.mouse_exited.connect(_on_unhover.bind($PlayButton))
	$SettingButton.mouse_entered.connect(_on_hover.bind($SettingButton))
	$SettingButton.mouse_exited.connect(_on_unhover.bind($SettingButton))
	$ExitButton.mouse_entered.connect(_on_hover.bind($ExitButton))
	$ExitButton.mouse_exited.connect(_on_unhover.bind($ExitButton))

func _on_hover(button):
	var tween = create_tween()
	tween.tween_property(button, "modulate", Color(1.3, 1.3, 1.3), 0.1)

func _on_unhover(button):
	var tween = create_tween()
	tween.tween_property(button, "modulate", Color(1, 1, 1), 0.1)

func _on_play():
	get_tree().change_scene_to_file("res://scene/story.tscn")

func _on_setting():
	get_tree().change_scene_to_file("res://scene/setting.tscn")

func _on_keluar():
	var popup = popup_keluar.instantiate()
	add_child(popup)

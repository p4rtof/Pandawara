extends Control

func _ready():
	MusicManager.putar("res://asset/audio/sound.ogg")
	$PlayButton.pressed.connect(_on_play)
	$SettingButton.pressed.connect(_on_setting)

func _on_play():
	get_tree().change_scene_to_file("res://scene/story.tscn")

func _on_setting():
	get_tree().change_scene_to_file("res://scene/setting.tscn")

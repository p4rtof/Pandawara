extends Control

func _ready():
	MusicManager.putar("res://asset/audio/sound.ogg")
	$PlayButton.pressed.connect(_on_play)

func _on_play():
	get_tree().change_scene_to_file("res://scene/story.tscn")

extends CanvasLayer

@onready var poin_label = $PoinLabel
@onready var hati1 = $Hati1
@onready var hati2 = $Hati2
@onready var hati3 = $Hati3
@onready var album_button = $AlbumButton

var album_scene = preload("res://scene/album.tscn")

func _ready():
	add_to_group("ui_layer")  # ← penting untuk popup!
	album_button.pressed.connect(_buka_album)

func _process(_delta):
	poin_label.text = "Poin: " + str(Global.poin)
	hati1.visible = Global.nyawa >= 1
	hati2.visible = Global.nyawa >= 2
	hati3.visible = Global.nyawa >= 3

func _buka_album():
	if get_tree().get_first_node_in_group("album"):
		return
	var album = album_scene.instantiate()
	album.add_to_group("album")
	add_child(album)

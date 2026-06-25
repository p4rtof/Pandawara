extends CanvasLayer

@onready var poin_label = $PoinLabel
@onready var hati1 = $Hati1
@onready var hati2 = $Hati2
@onready var hati3 = $Hati3
@onready var hati4 = $Hati4  # ← tambah ini
@onready var hati5 = $Hati5  # ← tambah ini
@onready var album_button = $AlbumButton

var album_scene = preload("res://scene/album.tscn")

func _ready():
	add_to_group("ui_layer")
	album_button.pressed.connect(_buka_album)

func _process(_delta):
	poin_label.text = "Poin: " + str(Global.poin)
	hati1.visible = Global.nyawa >= 1
	hati2.visible = Global.nyawa >= 2
	hati3.visible = Global.nyawa >= 3
	hati4.visible = Global.nyawa >= 4  # ← tambah ini
	hati5.visible = Global.nyawa >= 5  # ← tambah ini

func _buka_album():
	get_tree().paused = true
	if get_tree().get_first_node_in_group("album"):
		return
	var album = album_scene.instantiate()
	album.add_to_group("album")
	add_child(album)

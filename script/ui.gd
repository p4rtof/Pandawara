extends CanvasLayer

@onready var point_label  = $PoinLabel/Point
@onready var target_label = $PoinLabel/Target
@onready var hati1 = $Hati1
@onready var hati2 = $Hati2
@onready var hati3 = $Hati3
@onready var hati4 = $Hati4
@onready var hati5 = $Hati5
@onready var album_button = $AlbumButton
@onready var pause_button = $PauseButton   # ← BARU
@onready var koleksi_ikan_button = $KoleksiIkan

var album_scene = preload("res://scene/album.tscn")
var pause_menu_scene = preload("res://scene/pause_menu.tscn")   # ← BARU

func _ready():
	add_to_group("ui_layer")
	album_button.pressed.connect(_buka_album)
	pause_button.pressed.connect(_buka_pause)
	koleksi_ikan_button.pressed.connect(_buka_album)   # ← BARU

func _process(_delta):
	point_label.text  = str(Global.poin)
	target_label.text = "%d/%d" % [Global.sapu_sapu_ditangkap, Global.target_sapu_sapu]
	hati1.visible = Global.nyawa >= 1
	hati2.visible = Global.nyawa >= 2
	hati3.visible = Global.nyawa >= 3
	hati4.visible = Global.nyawa >= 4
	hati5.visible = Global.nyawa >= 5

func _buka_album():
	get_tree().paused = true
	if get_tree().get_first_node_in_group("album"):
		return
	var album = album_scene.instantiate()
	album.add_to_group("album")
	add_child(album)

func _buka_pause():   # ← BARU
	get_tree().paused = true
	if get_tree().get_first_node_in_group("pause_menu"):
		return
	var pause_menu = pause_menu_scene.instantiate()
	pause_menu.add_to_group("pause_menu")
	add_child(pause_menu)

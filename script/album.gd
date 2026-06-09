extends Control

@onready var ikan_list = $ScrollContainer/GridContainer
@onready var jumlah_label = $JumlahLabel
@onready var tutup_button = $TutupButton

func _ready():
	tutup_button.pressed.connect(_tutup_album)
	_tampilkan_koleksi()

func _tampilkan_koleksi():
	for child in ikan_list.get_children():
		child.queue_free()

	var koleksi = Global.album_koleksi
	jumlah_label.text = "Koleksi: %d ikan" % koleksi.size()

	for data in koleksi:
		# Panel kartu
		var kartu = PanelContainer.new()
		kartu.custom_minimum_size = Vector2(120, 150)

		var vbox = VBoxContainer.new()
		kartu.add_child(vbox)

		# Gambar ikan
		var img = TextureRect.new()
		img.texture = data["texture"]
		img.custom_minimum_size = Vector2(100, 100)
		img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		img.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		vbox.add_child(img)

		# Nama ikan
		var nama = Label.new()
		nama.text = data["nama"]
		nama.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		nama.add_theme_font_size_override("font_size", 12)
		vbox.add_child(nama)

		ikan_list.add_child(kartu)

func _tutup_album():
	queue_free()

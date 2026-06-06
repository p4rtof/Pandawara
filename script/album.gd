extends Control

@onready var ikan_list = $ScrollContainer/IkanList
@onready var tutup_button = $TutupButton
@onready var title_label = $TitleLabel
@onready var jumlah_label = $JumlahLabel

func _ready():
	tutup_button.pressed.connect(_on_tutup)
	title_label.text = "📖 Album Koleksi Ikan"
	_tampilkan_koleksi()

func _tampilkan_koleksi():
	# Hapus isi lama
	for child in ikan_list.get_children():
		child.queue_free()
	
	# Update jumlah koleksi
	jumlah_label.text = "Ditemukan: " + str(Global.album_koleksi.size()) + " ikan"
	
	if Global.album_koleksi.is_empty():
		var label = Label.new()
		label.text = "Belum ada ikan!\nTekan lama ikan untuk menambah ke album."
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 18)
		ikan_list.add_child(label)
		return
	
	for data in Global.album_koleksi:
		_buat_card(data)

func _buat_card(data: Dictionary):
	# Panel utama card
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(700, 110)
	
	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 16)
	
	# ── Gambar ikan (ukuran sama semua) ──
	var texture_rect = TextureRect.new()
	texture_rect.texture = data["texture"]
	texture_rect.custom_minimum_size = Vector2(90, 90)  # ukuran sama semua
	texture_rect.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	
	# ── Garis pemisah ──
	var separator = VSeparator.new()
	separator.custom_minimum_size.x = 2
	
	# ── Info ikan ──
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 6)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	# Nama ikan
	var nama_label = Label.new()
	nama_label.text = data["nama"]
	nama_label.add_theme_font_size_override("font_size", 20)
	
	# Jenis (badge warna beda)
	var jenis_label = Label.new()
	if data["adalah_sapu_sapu"]:
		jenis_label.text = "⭐ Ikan Target"
		jenis_label.add_theme_color_override("font_color", Color(1, 0.85, 0))
	else:
		jenis_label.text = "🐟 Ikan Biasa"
		jenis_label.add_theme_color_override("font_color", Color(0.6, 0.9, 1))
	jenis_label.add_theme_font_size_override("font_size", 14)
	
	# Deskripsi
	var desc_label = Label.new()
	desc_label.text = data["deskripsi"]
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	desc_label.add_theme_font_size_override("font_size", 13)
	desc_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	desc_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	vbox.add_child(nama_label)
	vbox.add_child(jenis_label)
	vbox.add_child(desc_label)
	
	hbox.add_child(texture_rect)
	hbox.add_child(separator)
	hbox.add_child(vbox)
	panel.add_child(hbox)
	ikan_list.add_child(panel)
	
	# Jarak antar card
	var spacer = Control.new()
	spacer.custom_minimum_size.y = 8
	ikan_list.add_child(spacer)

func _on_tutup():
	queue_free()

extends Control

const BIOMA = [
	{
		"nama": "HULU",
		"gambar": "res://asset/bg_sungai.png",
		"kunci_dari_bioma": -1,
		"kunci_poin": 0,
		"warna": Color("#4fc3f7"),
		"warna_gelap": Color("#0288d1"),
		"info": ["Tidak ada sampah", "Ikan jinak", "Tidak ada buaya"],
		"index": 0
	},
	{
		"nama": "PERTENGAHAN",
		"gambar": "res://asset/bg_blur.png",
		"kunci_dari_bioma": 0,
		"kunci_poin": 100,
		"warna": Color("#a5d6a7"),
		"warna_gelap": Color("#388e3c"),
		"info": ["Ada sedikit sampah", "Ikan lebih waspada"],
		"index": 1
	},
	{
		"nama": "PERKOTAAN",
		"gambar": "res://asset/bg_pantai.png",
		"kunci_dari_bioma": 1,
		"kunci_poin": 200,
		"warna": Color("#ffcc80"),
		"warna_gelap": Color("#e65100"),
		"info": ["Banyak sampah", "Ikan agresif", "Hati-hati buaya"],
		"index": 2
	}
]

@onready var hbox = $HBoxContainer
@onready var kembali_button = $KembaliButton

func _ready():
	kembali_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scene/mainmenu.tscn"))
	_buat_semua_kartu()

func _buat_semua_kartu():
	for data in BIOMA:
		hbox.add_child(_buat_kartu(data))

func _cek_terkunci(data: Dictionary) -> bool:
	if data["kunci_dari_bioma"] == -1:
		return false  # Hulu selalu terbuka
	var poin_bioma_syarat = Global.poin_per_bioma[data["kunci_dari_bioma"]]
	return poin_bioma_syarat < data["kunci_poin"]

func _buat_kartu(data: Dictionary) -> Control:
	var terkunci = _cek_terkunci(data)

	# Panel utama
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(280, 420)
	var style = StyleBoxFlat.new()
	style.bg_color = data["warna"]
	style.border_color = data["warna_gelap"]
	style.set_border_width_all(4)
	style.set_corner_radius_all(20)
	panel.add_theme_stylebox_override("panel", style)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)
	panel.add_child(vbox)

	# Nama bioma
	var nama = Label.new()
	nama.text = data["nama"]
	nama.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nama.add_theme_font_size_override("font_size", 22)
	nama.add_theme_color_override("font_color", Color.WHITE)
	vbox.add_child(nama)

	# Gambar bioma
	var gambar_cont = PanelContainer.new()
	gambar_cont.custom_minimum_size = Vector2(260, 180)
	var gambar_style = StyleBoxFlat.new()
	gambar_style.set_corner_radius_all(12)
	gambar_cont.add_theme_stylebox_override("panel", gambar_style)
	vbox.add_child(gambar_cont)

	var img = TextureRect.new()
	img.texture = load(data["gambar"])
	img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	img.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	img.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	gambar_cont.add_child(img)

	# Gembok jika terkunci
	if terkunci:
		var gembok = Label.new()
		gembok.text = "🔒"
		gembok.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		gembok.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		gembok.add_theme_font_size_override("font_size", 60)
		gembok.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		gambar_cont.add_child(gembok)

	# Info panel
	var info_panel = PanelContainer.new()
	var info_style = StyleBoxFlat.new()
	info_style.bg_color = Color(1, 1, 1, 0.3)
	info_style.set_corner_radius_all(10)
	info_panel.add_theme_stylebox_override("panel", info_style)
	vbox.add_child(info_panel)

	var info_vbox = VBoxContainer.new()
	info_panel.add_child(info_vbox)

	var tingkat_label = Label.new()
	tingkat_label.text = "Tingkat Sampah:"
	tingkat_label.add_theme_font_size_override("font_size", 12)
	info_vbox.add_child(tingkat_label)

	if terkunci:
		var nama_syarat = BIOMA[data["kunci_dari_bioma"]]["nama"]
		var locked_label = Label.new()
		locked_label.text = "Kumpulkan %d poin\ndi bioma %s dulu!" % [data["kunci_poin"], nama_syarat]
		locked_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		locked_label.add_theme_font_size_override("font_size", 11)
		info_vbox.add_child(locked_label)
	else:
		for info in data["info"]:
			var l = Label.new()
			l.text = "• " + info
			l.add_theme_font_size_override("font_size", 11)
			info_vbox.add_child(l)

	# Tombol
	var tombol = Button.new()
	tombol.custom_minimum_size = Vector2(240, 45)
	var tombol_style = StyleBoxFlat.new()
	tombol_style.set_corner_radius_all(20)

	if terkunci:
		tombol.text = "Terkunci"
		tombol.disabled = true
		tombol_style.bg_color = data["warna_gelap"]
	else:
		tombol.text = "Pilih"
		tombol_style.bg_color = Color("#1565c0")
		var idx = data["index"]
		tombol.pressed.connect(func(): _pilih_bioma(idx))

	tombol.add_theme_stylebox_override("normal", tombol_style)
	tombol.add_theme_color_override("font_color", Color.WHITE)
	tombol.add_theme_font_size_override("font_size", 16)
	vbox.add_child(tombol)

	return panel

func _pilih_bioma(index: int):
	Global.bioma_dipilih = index
	get_tree().change_scene_to_file("res://scene/game_sungai.tscn")

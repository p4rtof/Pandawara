extends Control

var data_bioma = [
	{
		"nama": "SUNGAI PERKOTAAN",
		"gambar": "res://asset/bg_sungai.png",
		"tingkat": "TINGGI",
		"tingkat_warna": Color(1, 0.2, 0.2),
		"deskripsi": "Cairan limbah berwarna gelap.",
		"icon": "🗑️",
		"kesulitan": 3,
		"index": 0
	},
	{
		"nama": "ALIRAN HUTAN",
		"gambar": "res://asset/bg_pantai.png",
		"tingkat": "RENDAH",
		"tingkat_warna": Color(0.2, 1, 0.2),
		"deskripsi": "Hambatan alami seperti ranting.",
		"icon": "🌿",
		"kesulitan": 1,
		"index": 1
	},
	{
		"nama": "MUARA PANTAI",
		"gambar": "res://asset/bg_malam.jpg",
		"tingkat": "SEDANG",
		"tingkat_warna": Color(1, 0.8, 0.1),
		"deskripsi": "Sampah laut menumpuk di pesisir.",
		"icon": "🐚",
		"kesulitan": 2,
		"index": 2
	},
]

@onready var bioma_cont = $BiomaCont
@onready var title_label = $TitleLabel

func _ready():
	MusicManager.putar("res://asset/audio/sound.ogg")
	title_label.text = "PILIH LOKASI MEMBERSIHKAN"
	
	# Tengahkan BiomaCont
	bioma_cont.alignment = BoxContainer.ALIGNMENT_CENTER
	bioma_cont.add_theme_constant_override("separation", 30)
	
	_buat_semua_kartu()

func _buat_semua_kartu():
	for bioma in data_bioma:
		bioma_cont.add_child(_buat_card(bioma))

func _buat_card(bioma: Dictionary) -> PanelContainer:
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(260, 420)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 8)

	# Nama
	var nama = Label.new()
	nama.text = bioma["nama"]
	nama.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nama.add_theme_font_size_override("font_size", 20)
	nama.add_theme_color_override("font_color", Color.WHITE)

	# Gambar
	var gambar = TextureRect.new()
	gambar.texture = load(bioma["gambar"])
	gambar.custom_minimum_size = Vector2(240, 160)
	gambar.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	gambar.expand_mode = TextureRect.EXPAND_FIT_WIDTH

	# Tingkat sampah
	var tingkat_hbox = HBoxContainer.new()
	tingkat_hbox.alignment = BoxContainer.ALIGNMENT_CENTER

	var tingkat_txt = Label.new()
	tingkat_txt.text = "Tingkat Sampah: "
	tingkat_txt.add_theme_font_size_override("font_size", 14)
	tingkat_txt.add_theme_color_override("font_color", Color.WHITE)

	var tingkat_val = Label.new()
	tingkat_val.text = bioma["tingkat"]
	tingkat_val.add_theme_font_size_override("font_size", 14)
	tingkat_val.add_theme_color_override("font_color", bioma["tingkat_warna"])

	tingkat_hbox.add_child(tingkat_txt)
	tingkat_hbox.add_child(tingkat_val)

	# Deskripsi + icon
	var desc_hbox = HBoxContainer.new()
	desc_hbox.add_theme_constant_override("separation", 8)

	var icon_label = Label.new()
	icon_label.text = bioma["icon"]
	icon_label.add_theme_font_size_override("font_size", 24)

	var desc = Label.new()
	desc.text = bioma["deskripsi"]
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD
	desc.add_theme_font_size_override("font_size", 13)
	desc.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9))
	desc.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	desc_hbox.add_child(icon_label)
	desc_hbox.add_child(desc)

	# Bintang
	var bintang_label = Label.new()
	var bintang_str = ""
	for i in 3:
		bintang_str += "⭐" if i < bioma["kesulitan"] else "☆"
	bintang_label.text = bintang_str
	bintang_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	bintang_label.add_theme_font_size_override("font_size", 20)

	# Tombol
	var btn = Button.new()
	btn.text = "PILIH"
	btn.custom_minimum_size = Vector2(200, 50)
	btn.add_theme_font_size_override("font_size", 22)
	btn.pressed.connect(_on_pilih.bind(bioma["index"]))

	vbox.add_child(nama)
	vbox.add_child(gambar)
	vbox.add_child(tingkat_hbox)
	vbox.add_child(desc_hbox)
	vbox.add_child(bintang_label)
	vbox.add_child(btn)
	panel.add_child(vbox)
	return panel

func _on_pilih(index: int):
	Global.bioma_dipilih = index
	
	# Arahkan ke scene sesuai bioma
	match index:
		0:
			get_tree().change_scene_to_file("res://scene/game_sungai.tscn")
		1:
			get_tree().change_scene_to_file("res://scene/game_hutan.tscn")
		2:
			get_tree().change_scene_to_file("res://scene/game_muara.tscn")

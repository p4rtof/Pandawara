extends Control

# Data tiap bioma
var data_bioma = [
	{
		"nama": "Sungai",
		"deskripsi": "Hulu sungai jernih\nPenuh ikan air tawar",
		"texture": "res://asset/bg_sungai.png",
		"index": 0
	},
	{
		"nama": "Danau",
		"deskripsi": "Danau tenang & dalam\nBanyak ikan langka",
		"texture": "res://asset/bg_pantai.png",
		"index": 1
	},
	{
		"nama": "Muara",
		"deskripsi": "Pertemuan sungai & laut\nIkan beragam jenis",
		"texture": "res://asset/bg_malam.jpg",
		"index": 2
	},
	{
		"nama": "Laut",
		"deskripsi": "Perairan dalam & luas\nIkan terbesar ada di sini",
		"texture": "res://asset/sapu_sapu.png",
		"index": 3
	}
]

@onready var bioma_cont = $BiomaCont
@onready var back_button = $BackButton

func _ready():
	back_button.pressed.connect(_on_back)
	_buat_kartu()

func _buat_kartu():
	for bioma in data_bioma:
		var card = _buat_card_bioma(bioma)
		bioma_cont.add_child(card)

func _buat_card_bioma(bioma: Dictionary) -> PanelContainer:
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(220, 320)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	
	# Gambar bioma
	var gambar = TextureRect.new()
	gambar.texture = load(bioma["texture"])
	gambar.custom_minimum_size = Vector2(200, 150)
	gambar.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	gambar.expand_mode = TextureRect.EXPAND_FIT_WIDTH
	
	# Nama bioma
	var nama = Label.new()
	nama.text = bioma["nama"]
	nama.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nama.add_theme_font_size_override("font_size", 22)
	
	# Deskripsi
	var desc = Label.new()
	desc.text = bioma["deskripsi"]
	desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD
	desc.add_theme_font_size_override("font_size", 13)
	desc.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	
	# Tombol pilih
	var btn = Button.new()
	btn.text = "Pilih Bioma"
	btn.custom_minimum_size = Vector2(180, 45)
	# Simpan index bioma di metadata tombol
	btn.set_meta("bioma_index", bioma["index"])
	btn.pressed.connect(_on_pilih_bioma.bind(bioma["index"]))
	
	vbox.add_child(gambar)
	vbox.add_child(nama)
	vbox.add_child(desc)
	vbox.add_child(btn)
	panel.add_child(vbox)
	
	return panel

func _on_pilih_bioma(index: int):
	# Simpan pilihan bioma ke Global
	Global.bioma_dipilih = index
	get_tree().change_scene_to_file("res://scene/game.tscn")

func _on_back():
	get_tree().change_scene_to_file("res://scene/mainmenu.tscn")

extends Control

@onready var ikan_list = $ScrollContainer/GridContainer
@onready var jumlah_label = $JumlahLabel
@onready var tutup_button = $TutupButton

const WARNA_RARITY = {
	"Umum":   Color("#2e7d32"),
	"Langka": Color("#1565c0"),
	"Epik":   Color("#6a1b9a"),
	"Legenda": Color("#e65100")
}

const WARNA_BADGE = {
	"Umum":   Color("#4caf50"),
	"Langka": Color("#2196f3"),
	"Epik":   Color("#9c27b0"),
	"Legenda": Color("#ff9800")
}

func _ready():
	tutup_button.pressed.connect(_tutup_album)
	_tampilkan_koleksi()

func _tampilkan_koleksi():
	for child in ikan_list.get_children():
		child.queue_free()

	var koleksi = Global.album_koleksi
	jumlah_label.text = "Koleksi: %d ikan" % koleksi.size()

	for data in koleksi:
		ikan_list.add_child(_buat_kartu(data))

func _buat_kartu(data: Dictionary) -> Control:
	var kelangkaan = data.get("kelangkaan", "Umum")

	# Panel utama kartu
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(130, 160)
	var style = StyleBoxFlat.new()
	style.bg_color = Color("#1a2a3a")
	style.border_color = WARNA_RARITY.get(kelangkaan, Color("#2e7d32"))
	style.set_border_width_all(3)
	style.set_corner_radius_all(10)
	panel.add_theme_stylebox_override("panel", style)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 4)
	panel.add_child(vbox)

	# Nama ikan (atas)
	var nama_label = Label.new()
	nama_label.text = data["nama"].to_upper()
	nama_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nama_label.add_theme_font_size_override("font_size", 11)
	nama_label.add_theme_color_override("font_color", Color.WHITE)
	vbox.add_child(nama_label)

	# Gambar ikan
	var img = TextureRect.new()
	img.texture = data["texture"]
	img.custom_minimum_size = Vector2(110, 90)
	img.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	img.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	vbox.add_child(img)

	# Badge kelangkaan (bawah)
	var badge_panel = PanelContainer.new()
	var badge_style = StyleBoxFlat.new()
	badge_style.bg_color = WARNA_BADGE.get(kelangkaan, Color("#4caf50"))
	badge_style.set_corner_radius_all(6)
	badge_panel.add_theme_stylebox_override("panel", badge_style)

	var badge_label = Label.new()
	badge_label.text = kelangkaan
	badge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge_label.add_theme_font_size_override("font_size", 10)
	badge_label.add_theme_color_override("font_color", Color.WHITE)
	badge_panel.add_child(badge_label)
	vbox.add_child(badge_panel)

	return panel

func _tutup_album():
	get_tree().paused = false
	queue_free()

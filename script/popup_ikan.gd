extends Control

@onready var gambar_ikan = $PanelContainer/VBox/GambarIkan
@onready var nama_label = $PanelContainer/VBox/NamaLabel
@onready var deskripsi_label = $PanelContainer/VBox/DeskripsiLabel

func tampilkan(data: Dictionary):
	nama_label.text = data["nama"]
	deskripsi_label.text = data["deskripsi"]
	
	if data.has("texture") and data["texture"] != null:
		gambar_ikan.texture = data["texture"]
		# Paksa ukuran gambar tidak melar!
		gambar_ikan.custom_minimum_size = Vector2(120, 120)
	
	# Paksa ukuran panel
	$PanelContainer.size = Vector2(400, 300)
	
	# Posisi tengah layar
	set_anchors_preset(Control.PRESET_CENTER)
	
	# Fade in
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.3)
	tween.tween_interval(3.0)
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(queue_free)

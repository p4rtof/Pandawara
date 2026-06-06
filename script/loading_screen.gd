extends Control

# ============================================================
#  Mas Arief: Ekspedisi Ciliwung — Loading Screen Controller
#  Engine  : Godot 4
#  Author  : [Your Name]
# ============================================================

# ── Node references ──────────────────────────────────────────
@onready var background        : TextureRect       = $Background
@onready var logo              : TextureRect       = $Logo
@onready var loading_bar       : TextureProgressBar = $LoadingBar
@onready var loading_label     : Label             = $LoadingText
@onready var tips_label        : Label             = $TipsLabel
@onready var fireflies         : GPUParticles2D    = $Fireflies
@onready var fog_particles     : GPUParticles2D    = $FogParticles
@onready var ambient_player    : AudioStreamPlayer = $AmbientPlayer
@onready var anim_player       : AnimationPlayer   = $AnimationPlayer
@onready var tip_timer         : Timer             = $TipTimer
@onready var text_timer        : Timer             = $TextTimer
@onready var chromatic_overlay : ColorRect         = $ChromaticOverlay

# ── Loading text rotation ─────────────────────────────────────
const LOADING_TEXTS : Array[String] = [
	"Menyiapkan ekspedisi...",
	"Menelusuri Sungai Ciliwung...",
	"Menganalisis ekosistem...",
	"Mencari ikan sapu-sapu...",
	"Membersihkan sungai...",
	"Membangunkan buaya...",
	"Memetakan jalur sungai...",
	"Mengecek kualitas air...",
]

# ── Gameplay tips ─────────────────────────────────────────────
const TIPS : Array[String] = [
	"💡 Ikan sapu-sapu lebih aktif di area tercemar.",
	"💡 Buaya sensitif terhadap cahaya terang.",
	"💡 Ikan langka hanya muncul di ekosistem sehat.",
	"💡 Ganggang hijau dapat memperlambat gerakanmu.",
	"💡 Bersihkan sampah untuk meningkatkan skor ekosistem.",
	"💡 Gunakan senter di malam hari untuk melihat lebih jauh.",
	"💡 Beberapa spesies hanya aktif saat hujan.",
]

# ── Internal state ────────────────────────────────────────────
var _loading_text_index : int   = 0
var _tip_index          : int   = 0
var _progress           : float = 0.0          # 0.0 – 1.0
var _target_scene       : String = ""          # set by caller
var _is_finishing       : bool  = false

# ── Tween handles ─────────────────────────────────────────────
var _logo_tween   : Tween
var _text_tween   : Tween
var _tip_tween    : Tween
var _finish_tween : Tween

# ─────────────────────────────────────────────────────────────
#  INITIALISATION
# ─────────────────────────────────────────────────────────────
func _ready() -> void:
	modulate.a = 0.0
	_generate_textures()
	_setup_shader_materials()
	_start_intro_sequence()
	_setup_timers()
	tip_timer.start()
	text_timer.start()


# ─────────────────────────────────────────────────────────────
#  PROCEDURAL TEXTURE GENERATION
#  bar_fill, bar_background, firefly_dot — no PNG needed
# ─────────────────────────────────────────────────────────────
func _generate_textures() -> void:

	# ── Bar fill ──────────────────────────────────────────────
	# Pure white; the water shader colorizes it entirely.
	var fill_img := Image.create(800, 32, false, Image.FORMAT_RGBA8)
	fill_img.fill(Color.WHITE)
	loading_bar.texture_progress = ImageTexture.create_from_image(fill_img)

	# ── Bar background ────────────────────────────────────────
	# Dark teal, soft-rounded edges via per-pixel alpha falloff.
	var bg_img := Image.create(800, 32, false, Image.FORMAT_RGBA8)
	var base_col := Color(0.04, 0.09, 0.14, 1.0)
	for x in range(800):
		for y in range(32):
			# distance to nearest horizontal / vertical edge in [0,1]
			var ex : float = minf(x, 799 - x) / 14.0
			var ey : float = minf(y, 31  - y) / 14.0
			var edge : float = minf(ex, ey)
			var a : float = clampf(edge, 0.0, 1.0) * 0.72
			bg_img.set_pixel(x, y, Color(base_col.r, base_col.g, base_col.b, a))
	loading_bar.texture_under = ImageTexture.create_from_image(bg_img)

	# ── Firefly dot ───────────────────────────────────────────
	# 32×32 warm-white radial glow, quadratic alpha falloff.
	const DOT := 32
	var dot_img := Image.create(DOT, DOT, false, Image.FORMAT_RGBA8)
	var center := Vector2(DOT * 0.5, DOT * 0.5)
	var radius : float = DOT * 0.46
	for x in range(DOT):
		for y in range(DOT):
			var dist : float = Vector2(x + 0.5, y + 0.5).distance_to(center)
			var a : float = clampf(1.0 - (dist / radius), 0.0, 1.0)
			a = a * a           # soft quadratic falloff
			dot_img.set_pixel(x, y, Color(1.0, 0.95, 0.55, a))
	fireflies.texture = ImageTexture.create_from_image(dot_img)


func _setup_shader_materials() -> void:
	# Ensure the loading bar uses the water shader material
	if loading_bar.material == null:
		loading_bar.material = load("res://shaders/water_bar.gdshader") as ShaderMaterial


# ─────────────────────────────────────────────────────────────
#  INTRO CINEMATIC SEQUENCE
# ─────────────────────────────────────────────────────────────
func _start_intro_sequence() -> void:
	var seq := create_tween().set_parallel(false)

	# 0s – fade from black
	seq.tween_property(self, "modulate:a", 1.0, 1.2)\
		.set_ease(Tween.EASE_IN_OUT)

	# 1s – ambient audio fades in
	seq.tween_callback(_fade_in_audio)

	# 2s – background slow zoom begins
	seq.tween_callback(_start_bg_zoom)

	# 3s – logo appears
	seq.tween_interval(0.6)
	seq.tween_callback(_show_logo)

	# 4s – fireflies activate
	seq.tween_interval(0.8)
	seq.tween_callback(_activate_fireflies)

	# 5s – loading text appears
	seq.tween_interval(0.6)
	seq.tween_callback(_show_loading_text)

	# 6s – loading bar activates
	seq.tween_interval(0.6)
	seq.tween_callback(_show_loading_bar)


func _fade_in_audio() -> void:
	if ambient_player and ambient_player.stream:
		ambient_player.volume_db = -40.0
		ambient_player.play()
		var t := create_tween()
		t.tween_property(ambient_player, "volume_db", -6.0, 2.5)\
			.set_ease(Tween.EASE_IN_OUT)


func _start_bg_zoom() -> void:
	var t := create_tween().set_loops()
	t.tween_property(background, "scale", Vector2(1.03, 1.03), 8.0)\
		.set_ease(Tween.EASE_IN_OUT)
	t.tween_property(background, "scale", Vector2(1.0, 1.0), 8.0)\
		.set_ease(Tween.EASE_IN_OUT)


func _show_logo() -> void:
	logo.modulate.a = 0.0
	logo.visible = true
	_logo_tween = create_tween()
	_logo_tween.tween_property(logo, "modulate:a", 1.0, 1.0)\
		.set_ease(Tween.EASE_OUT)
	_logo_tween.tween_callback(_start_logo_float)


func _start_logo_float() -> void:
	var t := create_tween().set_loops()
	t.tween_property(logo, "position:y", logo.position.y - 8.0, 2.5)\
		.set_ease(Tween.EASE_IN_OUT)
	t.tween_property(logo, "position:y", logo.position.y + 8.0, 2.5)\
		.set_ease(Tween.EASE_IN_OUT)
	# Glow pulse via modulate
	var g := create_tween().set_loops()
	g.tween_property(logo, "modulate", Color(1.15, 1.15, 1.25, 1.0), 2.0)\
		.set_ease(Tween.EASE_IN_OUT)
	g.tween_property(logo, "modulate", Color(1.0, 1.0, 1.0, 1.0), 2.0)\
		.set_ease(Tween.EASE_IN_OUT)


func _activate_fireflies() -> void:
	fireflies.emitting = true
	fog_particles.emitting = true


func _show_loading_text() -> void:
	loading_label.modulate.a = 0.0
	loading_label.visible = true
	loading_label.text = LOADING_TEXTS[0]
	var t := create_tween()
	t.tween_property(loading_label, "modulate:a", 1.0, 0.5)
	tips_label.modulate.a = 0.0
	tips_label.visible = true
	tips_label.text = TIPS[0]
	t.tween_property(tips_label, "modulate:a", 1.0, 0.8)


func _show_loading_bar() -> void:
	loading_bar.modulate.a = 0.0
	loading_bar.visible = true
	var t := create_tween()
	t.tween_property(loading_bar, "modulate:a", 1.0, 0.6)


# ─────────────────────────────────────────────────────────────
#  TIMER CALLBACKS  (text / tips rotation)
# ─────────────────────────────────────────────────────────────
func _setup_timers() -> void:
	text_timer.wait_time = 2.8
	text_timer.autostart = true
	text_timer.timeout.connect(_rotate_loading_text)

	tip_timer.wait_time = 5.0
	tip_timer.autostart = true
	tip_timer.timeout.connect(_rotate_tip)


func _rotate_loading_text() -> void:
	_text_tween = create_tween()
	_text_tween.tween_property(loading_label, "modulate:a", 0.0, 0.35)
	_text_tween.tween_callback(func():
		_loading_text_index = (_loading_text_index + 1) % LOADING_TEXTS.size()
		loading_label.text = LOADING_TEXTS[_loading_text_index]
	)
	_text_tween.tween_property(loading_label, "modulate:a", 1.0, 0.35)


func _rotate_tip() -> void:
	_tip_tween = create_tween()
	_tip_tween.tween_property(tips_label, "modulate:a", 0.0, 0.5)
	_tip_tween.tween_callback(func():
		_tip_index = (_tip_index + 1) % TIPS.size()
		tips_label.text = TIPS[_tip_index]
	)
	_tip_tween.tween_property(tips_label, "modulate:a", 1.0, 0.5)


# ─────────────────────────────────────────────────────────────
#  LOADING PROGRESS  (call this from your ResourceLoader loop)
# ─────────────────────────────────────────────────────────────
func set_progress(value: float) -> void:
	_progress = clampf(value, 0.0, 1.0)
	loading_bar.value = _progress * 100.0

	# Intensify bar glow as loading progresses
	if loading_bar.material is ShaderMaterial:
		loading_bar.material.set_shader_parameter(
			"glow_intensity", lerpf(0.3, 1.2, _progress)
		)

	if _progress >= 1.0 and not _is_finishing:
		_finish_loading()


# ─────────────────────────────────────────────────────────────
#  FINISH TRANSITION
# ─────────────────────────────────────────────────────────────
func _finish_loading() -> void:
	_is_finishing = true
	tip_timer.stop()
	text_timer.stop()

	# Bar glow burst
	if loading_bar.material is ShaderMaterial:
		var t := create_tween()
		t.tween_method(
			func(v: float): loading_bar.material.set_shader_parameter("glow_intensity", v),
			1.2, 2.5, 0.6
		)

	# Fade to black then switch scene
	_finish_tween = create_tween()
	_finish_tween.tween_interval(0.8)
	_finish_tween.tween_property(self, "modulate:a", 0.0, 1.4)\
		.set_ease(Tween.EASE_IN)
	_finish_tween.tween_callback(_switch_to_game)


func _switch_to_game() -> void:
	if _target_scene != "":
		get_tree().change_scene_to_file(_target_scene)
	else:
		push_warning("LoadingScreen: target_scene not set!")


# ─────────────────────────────────────────────────────────────
#  PUBLIC API  (call from GameLoader or autoload)
# ─────────────────────────────────────────────────────────────
func load_scene(path: String) -> void:
	_target_scene = path

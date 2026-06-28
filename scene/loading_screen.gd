extends Control

const NEXT_SCENE := "res://scene/mainmenu.tscn"
const MIN_LOADING_TIME := 2.0

@onready var bar_track: TextureRect = $ProgressBarContainer/BarTrack
@onready var bar_fill: Panel = $ProgressBarContainer/BarFill

var fill_max_width: float
var fill_padding: float = 6.0
var elapsed_time: float = 0.0
var resource_loaded: bool = false
var loaded_scene: PackedScene
var use_threaded: bool = true

func _ready() -> void:
	fill_max_width = bar_track.size.x - (fill_padding * 2)
	bar_fill.size.x = 0.0
	var err = ResourceLoader.load_threaded_request(NEXT_SCENE)
	if err != OK:
		push_warning("Threaded load gagal, pakai load biasa. Error: %d" % err)
		use_threaded = false
		loaded_scene = load(NEXT_SCENE)
		resource_loaded = true
	set_process(true)

func _process(delta: float) -> void:
	elapsed_time += delta

	if use_threaded and not resource_loaded:
		var progress_array := []
		var status := ResourceLoader.load_threaded_get_status(NEXT_SCENE, progress_array)
		if status == ResourceLoader.THREAD_LOAD_FAILED or status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			push_warning("Threaded load error, fallback ke load biasa.")
			use_threaded = false
			loaded_scene = load(NEXT_SCENE)
			resource_loaded = true
		elif status == ResourceLoader.THREAD_LOAD_LOADED:
			resource_loaded = true
			loaded_scene = ResourceLoader.load_threaded_get(NEXT_SCENE)

		var load_percent: float = 0.0
		if use_threaded:
			var prog := []
			ResourceLoader.load_threaded_get_status(NEXT_SCENE, prog)
			load_percent = prog[0] if prog.size() > 0 else (1.0 if resource_loaded else 0.0)
		else:
			load_percent = 1.0 if resource_loaded else 0.0

		var time_percent: float = clamp(elapsed_time / MIN_LOADING_TIME, 0.0, 1.0)
		bar_fill.size.x = fill_max_width * min(load_percent, time_percent)
	else:
		var time_percent: float = clamp(elapsed_time / MIN_LOADING_TIME, 0.0, 1.0)
		bar_fill.size.x = fill_max_width * time_percent

	if resource_loaded and elapsed_time >= MIN_LOADING_TIME:
		set_process(false)
		get_tree().change_scene_to_packed(loaded_scene)

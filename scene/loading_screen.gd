extends Control

const NEXT_SCENE := "res://scene/mainmenu.tscn"
const MIN_LOADING_TIME := .0  

@onready var bar_track: TextureRect = $ProgressBarContainer/BarTrack
@onready var bar_fill: Panel = $ProgressBarContainer/BarFill

var fill_max_width: float
var fill_padding: float = 6.0
var elapsed_time: float = 0.0
var resource_loaded: bool = false
var loaded_scene: PackedScene

func _ready() -> void:
	fill_max_width = bar_track.size.x - (fill_padding * 2)
	bar_fill.size.x = 0.0
	ResourceLoader.load_threaded_request(NEXT_SCENE)
	set_process(true)

func _process(delta: float) -> void:
	elapsed_time += delta

	var progress_array := []
	var status := ResourceLoader.load_threaded_get_status(NEXT_SCENE, progress_array)

	if status == ResourceLoader.THREAD_LOAD_LOADED and not resource_loaded:
		resource_loaded = true
		loaded_scene = ResourceLoader.load_threaded_get(NEXT_SCENE)

	var load_percent: float = progress_array[0] if progress_array.size() > 0 else (1.0 if resource_loaded else 0.0)
	var time_percent: float = clamp(elapsed_time / MIN_LOADING_TIME, 0.0, 1.0)
	var display_percent: float = min(load_percent, time_percent)

	bar_fill.size.x = fill_max_width * display_percent
	print("fill_max_width: ", fill_max_width, " | percent: ", display_percent, " | bar_fill size: ", bar_fill.size)

	if resource_loaded and elapsed_time >= MIN_LOADING_TIME:
		set_process(false)
		get_tree().change_scene_to_packed(loaded_scene)

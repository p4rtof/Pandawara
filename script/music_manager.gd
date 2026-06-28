extends Node

var player = AudioStreamPlayer.new()
var sfx_player = AudioStreamPlayer.new()
var lagu_sekarang = ""

const VOLUME_NORMAL = 0.0
const VOLUME_DUCK = -20.0   # ← seberapa kecil musik pas sound efek muncul

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(player)
	add_child(sfx_player)
	player.volume_db = VOLUME_NORMAL
	player.bus = "Music"      # ← BARU
	sfx_player.bus = "Music"

func putar(path: String):
	if lagu_sekarang == path:
		return
	lagu_sekarang = path

	var stream = load(path)
	if stream is AudioStreamOggVorbis:
		stream.loop = true
	elif stream is AudioStreamMP3:
		stream.loop = true

	player.stream = stream
	player.play()

func stop():
	player.stop()
	lagu_sekarang = ""

func putar_sfx(path: String):
	var stream = load(path)
	sfx_player.stream = stream
	sfx_player.play()

func kecilkan_musik():
	var tween = create_tween()
	tween.tween_property(player, "volume_db", VOLUME_DUCK, 0.3)

func kembalikan_musik():
	var tween = create_tween()
	tween.tween_property(player, "volume_db", VOLUME_NORMAL, 0.3)

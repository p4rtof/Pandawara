extends Node

var player = AudioStreamPlayer.new()
var lagu_sekarang = ""

func _ready():
	add_child(player)
	player.volume_db = 0.0

func putar(path: String):
	if lagu_sekarang == path:
		return
	lagu_sekarang = path
	
	var stream = load(path)
	
	# Set loop sesuai tipe file
	if stream is AudioStreamOggVorbis:
		stream.loop = true
	elif stream is AudioStreamMP3:
		stream.loop = true
	
	player.stream = stream
	player.play()

func stop():
	player.stop()
	lagu_sekarang = ""

extends Sprite2D

func _process(_delta):
	var player = get_tree().get_first_node_in_group("player")
	if player:
		# Background ikut posisi Y player biar tile ke atas
		var tex_height = texture.get_height()
		position.y = floor(player.position.y / tex_height) * tex_height

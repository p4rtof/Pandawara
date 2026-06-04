extends CanvasLayer

@onready var poin_label = $PoinLabel
@onready var hati1 = $Hati1
@onready var hati2 = $Hati2
@onready var hati3 = $Hati3

func _process(_delta):
	# Update score tiap frame
	poin_label.text = "Poin: " + str(Global.poin)
	
	# Update hati sesuai nyawa
	hati1.visible = Global.nyawa >= 1
	hati2.visible = Global.nyawa >= 2
	hati3.visible = Global.nyawa >= 3

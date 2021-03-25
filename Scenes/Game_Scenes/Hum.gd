extends AudioStreamPlayer

# signals --------------------------------------


# variables --------------------------------------
export var hum_id = 0


# main functions --------------------------------------
func _ready():
	# connect signals
	GSM.connect("show_hint", self, "_on_show_hint")


func _process(delta):
	pass


# helper functions --------------------------------------


# set/get functions --------------------------------------


# signal functions --------------------------------------
func _on_show_hint(hint_id):
	if hum_id == hint_id:
		play()

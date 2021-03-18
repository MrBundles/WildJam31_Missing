extends NinePatchRect

# signals --------------------------------------


# variables --------------------------------------
export var terminal_id = 0
var game_scene_id = 0
export var on = false setget set_on
export var on_color = Color(1,1,1,1)
export var off_color = Color(1,1,1,1)

# main functions --------------------------------------
func _ready():
	# connect signals
	GSM.connect("cable_charged", self, "_on_cable_charged")
	
	game_scene_id = GVM.game_scene
	self.on = false


func _process(delta):
	pass


# helper functions --------------------------------------


# set/get functions --------------------------------------
func set_on(new_val):
	on = new_val
	
	GSM.emit_signal("terminal_on", game_scene_id, terminal_id, on)
	
	if on:
		self_modulate = on_color
		if has_node("MarginContainer/OffRect"):
			$MarginContainer/OffRect.hide()
	else:
		self_modulate = off_color
		if has_node("MarginContainer/OffRect"):
			$MarginContainer/OffRect.show()


# signal functions --------------------------------------
func _on_cable_charged(new_game_scene_id, cable_id, cable_charged):
	if game_scene_id == new_game_scene_id and terminal_id == cable_id:
		self.on = cable_charged

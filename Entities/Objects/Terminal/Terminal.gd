extends NinePatchRect

# signals --------------------------------------


# variables --------------------------------------
export var terminal_id = 0
export var on = false setget set_on
export var on_color = Color(1,1,1,1)
export var off_color = Color(1,1,1,1)
export var hint_id = -1

# main functions --------------------------------------
func _ready():
	# connect signals
	GSM.connect("cable_charged", self, "_on_cable_charged")
	
	self.on = false


func _process(delta):
	pass


# helper functions --------------------------------------


# set/get functions --------------------------------------
func set_on(new_val):
	on = new_val
	
	GSM.emit_signal("terminal_on", terminal_id, on)
	
	if on:
		self_modulate = on_color
		
		if has_node("MarginContainer/OffRect"):
			$MarginContainer/OffRect.hide()
		
		if hint_id != -1:
			GSM.emit_signal("show_hint", hint_id)
		
	else:
		self_modulate = off_color
		
		if has_node("MarginContainer/OffRect"):
			$MarginContainer/OffRect.show()
		
		if hint_id != -1:
			GSM.emit_signal("hide_hint", hint_id)


# signal functions --------------------------------------
func _on_cable_charged(cable_type, cable_id, cable_charged, scene_transition_type):
	if terminal_id == cable_id:
		self.on = cable_charged

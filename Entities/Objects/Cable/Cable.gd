extends Path2D

# signals --------------------------------------


# variables --------------------------------------
export var cable_id = 0
var power_progress = 0.0
var cable_charged = false
export var power_progress_mult = 1000
export var on_color = Color(1,1,1,1)
export var off_color = Color(1,1,1,1)
export var cable_width = 10

export var active = false setget set_active


# main functions --------------------------------------
func _ready():
	# connect signals
	GSM.connect("socket_plugged", self, "_on_socket_plugged")


func _process(delta):
	update()


func _draw():
	var point_colors = []
	for i in range(curve.get_baked_points().size()):
		if float(i) / curve.get_baked_points().size() < power_progress:
			point_colors.append(on_color)
		else:
			point_colors.append(off_color)
	
	draw_polyline_colors(curve.get_baked_points(), PoolColorArray(point_colors), cable_width, true)


# helper functions --------------------------------------


# set/get functions --------------------------------------
func set_active(new_val):
	active = new_val
	
	var tween_duration = curve.get_baked_length() / power_progress_mult
	$Tween.stop_all()
	$Tween.remove_all()
	
	if active:
		$Tween.interpolate_property(self, "power_progress", power_progress, 1.0, tween_duration, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.0)
	else:
		GSM.emit_signal("cable_charged", cable_id, false)
		$Tween.interpolate_property(self, "power_progress", power_progress, 0.0, tween_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.0)
	
	$Tween.start()
	
	
# signal functions --------------------------------------
func _on_socket_plugged(socket_id, plugged_in):
	if socket_id == cable_id:
		self.active = plugged_in


func _on_Tween_tween_all_completed():
	if power_progress == 1.0:
		GSM.emit_signal("cable_charged", cable_id, true)
		if cable_id == GEM.RESERVED_IDS.end:
			GSM.emit_signal("level_complete")
			print("level_complete")

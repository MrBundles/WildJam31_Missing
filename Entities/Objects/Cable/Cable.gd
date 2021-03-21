extends Path2D

# signals --------------------------------------


# variables --------------------------------------
export var cable_id = 0
export(GEM.CABLE_TYPES) var cable_type = GEM.CABLE_TYPES.drain
var power_progress = 0.0
var cable_charged = false
export var power_progress_mult = 1000
export var power_progress_mult_debug = 2000
var on_color = Color(1,1,1,1)
var off_color = Color(1,1,1,1)
export var cable_width = 10
export(GEM.SCENE_TRANSITION_TYPES) var scene_transition_type = GEM.SCENE_TRANSITION_TYPES.up
export var start_end_color = Color(1,1,1,1)
export var drain_color = Color(1,1,1,1)
export var charge_color = Color(1,1,1,1)
export var secret_color = Color(1,1,1,1)
export var null_color = Color(1,1,1,1)

export var active = false setget set_active


# main functions --------------------------------------
func _ready():
	# connect signals
	GSM.connect("socket_plugged", self, "_on_socket_plugged")
	
	if GVM.debug_mode:
		power_progress_mult = power_progress_mult_debug
	
	init_cable()
	

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
func init_cable():
	#set off color
	off_color = null_color
	
	#set on color and start active
	match cable_type:
		GEM.CABLE_TYPES.drain:
			on_color = drain_color
		GEM.CABLE_TYPES.charge:
			on_color = charge_color
		GEM.CABLE_TYPES.start:
			on_color = start_end_color
			self.active = true
		GEM.CABLE_TYPES.end:
			on_color = start_end_color
		GEM.CABLE_TYPES.secret:
			on_color = secret_color
			off_color.a = 0


# set/get functions --------------------------------------
func set_active(new_val):
	if cable_type == GEM.CABLE_TYPES.secret and not new_val:
		return
	
	active = new_val
	
	var tween_duration = curve.get_baked_length() / power_progress_mult
	$Tween.stop_all()
	$Tween.remove_all()
	
	if active:
		$Tween.interpolate_property(self, "power_progress", power_progress, 1.0, tween_duration, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.0)
	else:
		$Tween.interpolate_property(self, "power_progress", power_progress, 0.0, tween_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.0)
		GSM.emit_signal("cable_charged", cable_type, cable_id, false, scene_transition_type)
		
	$Tween.start()
	
	
# signal functions --------------------------------------
func _on_socket_plugged(socket_type, socket_id, plugged_in):
	if socket_id == cable_id and cable_type != GEM.CABLE_TYPES.start:
		self.active = plugged_in


func _on_Tween_tween_all_completed():
	if power_progress == 1.0:
		GSM.emit_signal("cable_charged", cable_type, cable_id, true, scene_transition_type)

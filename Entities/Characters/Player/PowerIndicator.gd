extends HSlider

# signals --------------------------------------


# variables --------------------------------------
export var id = 0
export var delay_mult = 0.1
var active = true setget set_active
var power_on = false setget set_power_on

# main functions --------------------------------------
func _ready():
	# connect signals
	
	pass


func _process(delta):
	pass


# helper functions --------------------------------------


# set/get functions --------------------------------------
func set_active(new_val):
	active = new_val
	$Tween.stop_all()
	$Tween.remove_all()
	
	if active and power_on:
		$Tween.interpolate_property(self, "value", value, 100, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT, id * delay_mult)
	else:
		$Tween.interpolate_property(self, "value", value, 0, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT, 5 * delay_mult - id * delay_mult)
	
	$Tween.start()


func set_power_on(new_val):
	power_on = new_val
	$Tween.stop_all()
	$Tween.remove_all()
	
	if power_on:
		$Tween.interpolate_property(self, "value", value, 100, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT, 0.0)
	else:
		$Tween.interpolate_property(self, "value", value, 0, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT, 0.0)
	
	$Tween.start()


# signal functions --------------------------------------

extends HSlider

# signals --------------------------------------


# variables --------------------------------------
export var id = 0
export var delay_mult = 0.1
var active = true setget set_active
var power_on = true

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
	
	if active and power_on:
		$Tween.interpolate_property(self, "value", value, 100, 1.0, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT, id * delay_mult)
	else:
		$Tween.interpolate_property(self, "value", value, 0, 1.0, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT, 5 * delay_mult - id * delay_mult)
	
	$Tween.start()

# signal functions --------------------------------------

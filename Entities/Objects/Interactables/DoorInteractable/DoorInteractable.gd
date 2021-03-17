extends Interactable

# signals --------------------------------------


# variables --------------------------------------


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
	
#	$Tween.stop_all()
#	$Tween.remove_all()
#
#	if active:
#		$Tween.interpolate_property($SocketSprite, "position:y", $SocketSprite.position.y, -$SocketSprite.texture.get_size().y/2, 0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT, 0.0)
#		$Tween.interpolate_property($BatteryIconSprite, "modulate", $BatteryIconSprite.modulate, Color(1,1,1,0), 0.25, Tween.TRANS_QUAD, Tween.EASE_OUT, 0.0)
#	else:
#		$Tween.interpolate_property($SocketSprite, "position:y", $SocketSprite.position.y, $SocketSprite.texture.get_size().y/2, 0.5, Tween.TRANS_QUART, Tween.EASE_OUT, 0.0)
#		$Tween.interpolate_property($BatteryIconSprite, "modulate", $BatteryIconSprite.modulate, battery_icon_color, 0.25, Tween.TRANS_QUAD, Tween.EASE_OUT, 0.0)
#
#	$Tween.start()


# signal functions --------------------------------------

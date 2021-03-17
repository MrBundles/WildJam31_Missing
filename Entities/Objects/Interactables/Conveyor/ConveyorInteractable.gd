extends Interactable

# signals --------------------------------------


# variables --------------------------------------


# main functions --------------------------------------
func _ready():
	# connect signals
	
	init_conveyor_color()
	init_conveyor_orientation()


func _process(delta):
	match i_mode:
		GEM.I_MODES.manual:
			get_input()
			linear_velocity = speed
		GEM.I_MODES.auto:
			linear_velocity = auto_speed
		GEM.I_MODES.off:
			linear_velocity = Vector2.ZERO
	
	
	if orientation == GEM.ORIENTATIONS.horizontal:
		$StripeSprite.texture.region.position.x -= linear_velocity.x * delta
	else:
		$StripeSprite.texture.region.position.x -= linear_velocity.y * delta
	
	update_conveyor_color()


# helper functions --------------------------------------
func get_input():
		if Input.is_action_pressed("ui_left") and active:
			speed.x = clamp(speed.x - accel.x, -speed_max.x, speed_max.x)
		elif Input.is_action_pressed("ui_right") and active:
			speed.x = clamp(speed.x + accel.x, -speed_max.x, speed_max.x)
		elif speed.x <= -decel.x:
			speed.x = clamp(speed.x + decel.x, -speed_max.x, speed_max.x)
		elif speed.x >= decel.x:
			speed.x = clamp(speed.x - decel.x, -speed_max.x, speed_max.x)
		else:
			speed.x = 0
		
		if Input.is_action_pressed("ui_up") and active:
			speed.y = clamp(speed.x - accel.y, -speed_max.y, speed_max.y)
		elif Input.is_action_pressed("ui_down") and active:
			speed.y = clamp(speed.y + accel.y, -speed_max.y, speed_max.y)
		elif speed.y <= -decel.y:
			speed.y = clamp(speed.y + decel.y, -speed_max.y, speed_max.y)
		elif speed.y >= decel.y:
			speed.y = clamp(speed.y - decel.y, -speed_max.y, speed_max.y)
		else:
			speed.y = 0


func init_conveyor_color():
	if active:
		$BackgroundSprite.modulate = active_color
	else:
		$BackgroundSprite.modulate = inactive_color


func init_conveyor_orientation():
	if orientation == GEM.ORIENTATIONS.horizontal:
		$StripeSprite.rotation_degrees = 0
	else:
		$StripeSprite.rotation_degrees = 90


func update_conveyor_color():
	var lerp_rate = 0.05
	
	if active:
		$BackgroundSprite.modulate = lerp($BackgroundSprite.modulate, active_color, lerp_rate)
	else:
		$BackgroundSprite.modulate = lerp($BackgroundSprite.modulate, inactive_color, lerp_rate)


# set/get functions --------------------------------------
func set_orientation(new_val):
	orientation = new_val
	
	if orientation == GEM.ORIENTATIONS.horizontal:
		$StripeSprite.rotation_degrees = 0
	else:
		$StripeSprite.rotation_degrees = 90

# signal functions --------------------------------------

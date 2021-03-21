extends Interactable

# signals --------------------------------------


# variables --------------------------------------


# main functions --------------------------------------
func _ready():
	# connect signals
	
	self.orientation = orientation
	
	init_door_color()
	init_door_position()


func _physics_process(delta):
	match i_mode:
		GEM.I_MODES.manual:
			get_input()
		GEM.I_MODES.auto:
			pass
		GEM.I_MODES.off:
			pass
	
	update_door_color()
	update_door_position()
	update_door_collision()
	update_door_orientation()


# helper functions --------------------------------------
func get_input():
	#set limits
	speed_max.x = right_limit
	speed_min.x = left_limit
	speed_max.y = lower_limit
	speed_min.y = upper_limit
	
	if Input.is_action_pressed("ui_left") and active:
		speed.x = clamp(speed.x - accel.x, speed_min.x, speed_max.x)
	elif Input.is_action_pressed("ui_right") and active:
		speed.x = clamp(speed.x + accel.x, speed_min.x, speed_max.x)
	
	if Input.is_action_pressed("ui_up") and active:
		speed.y = clamp(speed.y - accel.y, speed_min.y, speed_max.y)
	elif Input.is_action_pressed("ui_down") and active:
		speed.y = clamp(speed.y + accel.y, speed_min.y, speed_max.y)


func init_door_color():
	if active:
		$BackgroundSprite.modulate = active_color
		$FrameSprite.modulate = active_color.lightened(0)
	else:
		$BackgroundSprite.modulate = inactive_color
		$FrameSprite.modulate = inactive_color.lightened(0)


func init_door_position():
	if orientation == GEM.ORIENTATIONS.horizontal:
		speed.x = speed_max.x
	else:
		speed.y = speed_max.y


func update_door_color():
	var lerp_rate = 0.05
	
	if active:
		$BackgroundSprite.modulate = lerp($BackgroundSprite.modulate, active_color, lerp_rate)
		$FrameSprite.modulate = lerp($FrameSprite.modulate, active_color.lightened(0), lerp_rate)
	else:
		$BackgroundSprite.modulate = lerp($BackgroundSprite.modulate, inactive_color, lerp_rate)
		$FrameSprite.modulate = lerp($FrameSprite.modulate, inactive_color.lightened(0), lerp_rate)
	
	$FrameSprite.modulate.a = 1


func update_door_position():
	var speed_range = speed_max - speed_min
	var range_block_count = speed_range / Vector2(64,64)
	var my_block = (global_position - speed_min) / Vector2(64,64)
	var cut_speed = speed - speed_min
	var param_val = cut_speed - (Vector2(64,64) * (my_block - Vector2(1,1)))
	var extent_val = (Vector2(32,32) * my_block) - cut_speed / Vector2(2,2)
	
	
	if orientation == GEM.ORIENTATIONS.vertical:
#		print("left: " + str(left_limit) + "    right: " + str(right_limit) + "    upper: " + str(upper_limit) + "    lower: " + str(lower_limit) + "    speed: " + str(speed) + "    accel: " + str(accel) + "    min: " + str(speed_min) + "    max: " + str(speed_max), "    block_count: " + str(range_block_count) + "    my block: " + str(my_block) + "    cut speed: " + str(cut_speed))
		$BackgroundSprite.material.set_shader_param("h_orientation", false)
		$BackgroundSprite.material.set_shader_param("limit", Vector2(0, param_val.y))
		$CollisionShape2D.shape.extents = Vector2(32, clamp(extent_val.y, 0, 32))
		$CollisionShape2D.position = Vector2(0, clamp(32 - extent_val.y, 0, 32))
	else:
#		print("left: " + str(left_limit) + "    right: " + str(right_limit) + "    upper: " + str(upper_limit) + "    lower: " + str(lower_limit) + "    speed: " + str(speed) + "    accel: " + str(accel) + "    min: " + str(speed_min) + "    max: " + str(speed_max), "    block_count: " + str(range_block_count) + "    my block: " + str(my_block) + "    cut speed: " + str(cut_speed))
		$BackgroundSprite.material.set_shader_param("h_orientation", true)
		$BackgroundSprite.material.set_shader_param("limit", Vector2(param_val.x, 0))
		$CollisionShape2D.shape.extents = Vector2(clamp(extent_val.x, 0, 32), 32)
		$CollisionShape2D.position = Vector2(clamp(32 - extent_val.x, 0, 32), 0)


func update_door_collision():
	if orientation == GEM.ORIENTATIONS.vertical:
		set_collision_layer_bit(0, not $CollisionShape2D.shape.extents.y == 0)
		set_collision_mask_bit(0, not $CollisionShape2D.shape.extents.y == 0)
	elif orientation == GEM.ORIENTATIONS.horizontal:
		set_collision_layer_bit(0, not $CollisionShape2D.shape.extents.x == 0)
		set_collision_mask_bit(0, not $CollisionShape2D.shape.extents.x == 0)


func update_door_orientation():
	if orientation == GEM.ORIENTATIONS.horizontal:
		$FrameSprite.rotation_degrees = 90
	else:
		$FrameSprite.rotation_degrees = 0

# set/get functions --------------------------------------


# signal functions --------------------------------------

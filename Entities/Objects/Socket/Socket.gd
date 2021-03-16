extends Area2D

# signals --------------------------------------


# variables --------------------------------------
export var socket_id = 0
export var active = false setget set_active
export var tab_active = false setget set_tab_active
export(Texture) var socket_off_texture
export(Texture) var socket_on_texture
export var battery_icon_color = Color(1,1,1,1)
var player = null
var plugged_in = false

export var max_player_align_distance = 32


# main functions --------------------------------------
func _ready():
	# connect signals
	
	pass


func _process(delta):
	if $Tween.is_active():
		$SocketSprite.material.set_shader_param("limit", Vector2(0, -$SocketSprite.position.y + $SocketSprite.texture.get_size().y/2))
	
	get_input(delta)


# helper functions --------------------------------------
func get_input(delta):
	if player and Input.is_action_just_pressed("plug"):
		player.socket_align_x = global_position.x
		self.tab_active = player.alive



# set/get functions --------------------------------------
func set_active(new_val):
	active = new_val
	
	$Tween.stop_all()
	$Tween.remove_all()
	
	if active:
		$Tween.interpolate_property($SocketSprite, "position:y", $SocketSprite.position.y, -$SocketSprite.texture.get_size().y/2, 0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT, 0.0)
		$Tween.interpolate_property($BatteryIconSprite, "modulate", $BatteryIconSprite.modulate, Color(1,1,1,0), 0.25, Tween.TRANS_QUAD, Tween.EASE_OUT, 0.0)
	else:
		$Tween.interpolate_property($SocketSprite, "position:y", $SocketSprite.position.y, $SocketSprite.texture.get_size().y/2, 0.5, Tween.TRANS_QUART, Tween.EASE_OUT, 0.0)
		$Tween.interpolate_property($BatteryIconSprite, "modulate", $BatteryIconSprite.modulate, battery_icon_color, 0.25, Tween.TRANS_QUAD, Tween.EASE_OUT, 0.0)
	
	$Tween.start()
	
	
func set_tab_active(new_val):
	tab_active = new_val

	$TabTween.stop_all()
	$TabTween.remove_all()
	
	if tab_active:
		$TabTween.interpolate_property($TabSprite, "scale:y", $TabSprite.scale.y, 0, 0.5, Tween.TRANS_QUART, Tween.EASE_OUT, 0.0)
		$TabTween.interpolate_property($TabSprite, "position:y", $TabSprite.position.y, -135, 0.5, Tween.TRANS_QUART, Tween.EASE_OUT, 0.0)
	else:
		$TabTween.interpolate_property($TabSprite, "scale:y", $TabSprite.scale.y, 1, 0.5, Tween.TRANS_QUART, Tween.EASE_OUT, 0.5)
		$TabTween.interpolate_property($TabSprite, "position:y", $TabSprite.position.y, -120, 0.5, Tween.TRANS_QUART, Tween.EASE_OUT, 0.5)
			
	$TabTween.start()
	
	
# signal functions --------------------------------------
func _on_Socket_body_entered(body):
	if body.is_in_group("player"):
		self.active = true
		player = body


func _on_Socket_body_exited(body):
	if body.is_in_group("player"):
		self.active = false
		player = null


func _on_TabTween_tween_all_completed():
	if $TabSprite.scale.y == 1 and player.remaining_power > 0:
		plugged_in = true
		$SocketSprite.texture = socket_on_texture
	else:
		plugged_in = false
		$SocketSprite.texture = socket_off_texture

	if player:
		player.plugged_in = plugged_in
		GSM.emit_signal("socket_plugged", socket_id, plugged_in)
	else:
		GSM.emit_signal("socket_plugged", socket_id, false)

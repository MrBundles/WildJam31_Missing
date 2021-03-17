extends Area2D

# signals --------------------------------------


# variables --------------------------------------
export var socket_id = 0
export(GEM.SOCKET_TYPES) var socket_type = GEM.SOCKET_TYPES.drain
export var active = false setget set_active
export var tab_active = false setget set_tab_active
export(Texture) var battery_icon
export(Texture) var charge_icon
export(Texture) var finish_icon
export var on_color = Color(1,1,1,1)
export var off_color = Color(1,1,1,1)
export var start_end_color = Color(1,1,1,1)
export var drain_color = Color(1,1,1,1)
export var charge_color = Color(1,1,1,1)
export var null_color = Color(1,1,1,1)
export var battery_icon_color = Color(1,1,1,1)
var player = null
var plugged_in = false setget set_plugged_in

export var max_player_align_distance = 32


# main functions --------------------------------------
func _ready():
	# connect signals
	GSM.connect("cable_charged", self, "_on_cable_charged")
	
	init_socket()


func _process(delta):
	if $Tween.is_active():
		for sprite in $SocketSprites.get_children():
			sprite.material.set_shader_param("limit", Vector2(0, -$SocketSprites.position.y + sprite.texture.get_size().y/2))
	
	if socket_type != GEM.SOCKET_TYPES.start:
		get_input(delta)


# helper functions --------------------------------------
func get_input(delta):
	if player and Input.is_action_just_pressed("plug"):
		player.socket_align_x = global_position.x
		self.tab_active = player.alive


func init_socket():
	match socket_type:
		GEM.SOCKET_TYPES.drain:
			$BatteryIconSprite.texture = battery_icon
			$SocketSprites/SocketBackground.modulate = null_color
		GEM.SOCKET_TYPES.charge:
			$BatteryIconSprite.texture = charge_icon
			$SocketSprites/SocketBackground.modulate = null_color
		GEM.SOCKET_TYPES.start:
			self.active = true
			self.tab_active = false
			$BatteryIconSprite.hide()
			$SocketSprites/SocketBackground.modulate = null_color
			GSM.emit_signal("socket_plugged", GEM.RESERVED_IDS.start, true)
		GEM.SOCKET_TYPES.end:
			$BatteryIconSprite.texture = finish_icon
			$SocketSprites/SocketBackground.modulate = null_color


# set/get functions --------------------------------------
func set_active(new_val):
	active = new_val
	
	$Tween.stop_all()
	$Tween.remove_all()
	
	if active:
		$Tween.interpolate_property($SocketSprites, "position:y", $SocketSprites.position.y, -$SocketSprites.get_child(0).texture.get_size().y/2, 0.5, Tween.TRANS_BOUNCE, Tween.EASE_OUT, 0.0)
		$Tween.interpolate_property($BatteryIconSprite, "modulate", $BatteryIconSprite.modulate, Color(1,1,1,0), 0.25, Tween.TRANS_QUAD, Tween.EASE_OUT, 0.0)
	else:
		$Tween.interpolate_property($SocketSprites, "position:y", $SocketSprites.position.y, $SocketSprites.get_child(0).texture.get_size().y/2, 0.5, Tween.TRANS_QUART, Tween.EASE_OUT, 0.0)
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


func set_plugged_in(new_val):
	plugged_in = new_val
	
	if player and not (socket_type == GEM.SOCKET_TYPES.start and not plugged_in) and not (socket_type == GEM.SOCKET_TYPES.drain and player.remaining_power < 1):
		player.plugged_in = plugged_in
		GSM.emit_signal("socket_plugged", socket_id, plugged_in)
	elif socket_type != GEM.SOCKET_TYPES.start:
		GSM.emit_signal("socket_plugged", socket_id, false)
	
	if plugged_in:
		match socket_type:
			GEM.SOCKET_TYPES.drain:
				$SocketSprites/SocketLight.modulate = drain_color
			GEM.SOCKET_TYPES.charge:
				GSM.emit_signal("charge_battery")
				$SocketSprites/SocketLight.modulate = charge_color
			GEM.SOCKET_TYPES.start:
				$SocketSprites/SocketLight.modulate = start_end_color
			GEM.SOCKET_TYPES.end:
				$SocketSprites/SocketLight.modulate = start_end_color
	else:
		if socket_type == GEM.SOCKET_TYPES.start:
			self.active = false
		$SocketSprites/SocketLight.modulate = off_color


# signal functions --------------------------------------
func _on_cable_charged(cable_id, cable_charged):
	if socket_type == GEM.SOCKET_TYPES.start and cable_id == GEM.RESERVED_IDS.start and cable_charged and player:
		if player.sleep_at_start:
			self.plugged_in = true
			$StartDelayTimer.start()


func _on_Socket_body_entered(body):
	if body.is_in_group("player"):
		player = body
		
		if socket_type != GEM.SOCKET_TYPES.start:
			self.active = true


func _on_Socket_body_exited(body):
	if body.is_in_group("player"):
		self.active = false
		player = null


func _on_TabTween_tween_all_completed():
	self.plugged_in = $TabSprite.scale.y == 1


func _on_StartDelayTimer_timeout():
	player.sleep_at_start = false
	Input.action_press("plug")
	self.tab_active = true
	$StartDelayTimer.stop()

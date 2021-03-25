tool
extends Area2D

# signals --------------------------------------


# variables --------------------------------------
export var secret_display_id = -1
var label_text = "" setget set_label_text

var active = false setget set_active
export var active_y = -64
export var inactive_y = -32

var color = Color(1,1,1,1) setget set_color
export var active_color = Color(1,1,1,1)
export var inactive_color = Color(1,1,1,1)


# main functions --------------------------------------
func _ready():
	# connect signals
	
	init_label_mod()
	
	self.label_text = "Level " + str(secret_display_id)[-1]
	
	#set color of top sprite
	if secret_display_id in GVM.secret_array:
		self.color = active_color
	else:
		self.color = inactive_color


func _process(delta):
	update_label_mod()


# helper functions --------------------------------------
func init_label_mod():
	if has_node("Label") and has_node("SecretFound"):
		$Label.modulate.a = 0.0
		$SecretFound.modulate.a = 0.0
		
		if secret_display_id in GVM.secret_array:
			$SecretFound.text = "Secret Found"
		else:
			$SecretFound.text = "Secret Not Found"


func update_label_mod():
	var lerp_rate = 0.2

	if active and $TopSprite.rotation_degrees > 150:
		$Label.modulate.a = lerp($Label.modulate.a, 1.0, lerp_rate)
		$SecretFound.modulate.a = lerp($SecretFound.modulate.a, 1.0, lerp_rate)
	else:
		$Label.modulate.a = lerp($Label.modulate.a, 0.0, lerp_rate)
		$SecretFound.modulate.a = lerp($SecretFound.modulate.a, 0.0, lerp_rate)


# set/get functions --------------------------------------
func set_label_text(new_val):
	label_text = new_val
	
	if has_node("Label"):
		$Label.text = label_text


func set_active(new_val):
	active = new_val
	
	$Tween.stop_all()
	$Tween.remove_all()
	
	if active:
		$Tween.interpolate_property($TopSprite, "position:y", $TopSprite.position.y, active_y, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT, 0.0)
		$Tween.interpolate_property($TopSprite, "rotation_degrees", $TopSprite.rotation_degrees, 180, 0.5, Tween.TRANS_QUART, Tween.EASE_OUT, 0.25)
	else:
		$Tween.interpolate_property($TopSprite, "position:y", $TopSprite.position.y, inactive_y, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT, 0.25)
		$Tween.interpolate_property($TopSprite, "rotation_degrees", $TopSprite.rotation_degrees, 0, 0.5, Tween.TRANS_QUART, Tween.EASE_OUT, 0.0)
	
	$Tween.start()


func set_color(new_val):
	color = new_val
	
	if has_node("TopSprite") and has_node("Label") and has_node("SecretFound"):
		$TopSprite.modulate = color
		$Label.modulate = color
		$SecretFound.modulate = color


# signal functions --------------------------------------


func _on_SecretDisplay_body_entered(body):
	if body.is_in_group("player"):
		self.active = true


func _on_SecretDisplay_body_exited(body):
	if body.is_in_group("player"):
		self.active = false

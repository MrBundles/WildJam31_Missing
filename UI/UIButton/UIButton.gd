tool
extends Button

#variables
export(Texture) var icon_texture setget set_icon_texture
export(GEM.MENU_SCENE_IDS) var menu_scene_id = GEM.MENU_SCENE_IDS.pause
export(Array, String) var additional_signals = []
export var rotation_speed = 1000
export var label = "" setget set_label


func _ready():
	$Label.modulate = Color(1,1,1,0)


func set_label(new_val):
	label = new_val
	
	if has_node("Label"):
		$Label.text = label


func set_icon_texture(new_val):
	icon_texture = new_val
	
	if has_node("Icon"):
		$Icon.texture = icon_texture


func _on_UIButton_pressed():
	tween_rotation(0, Color(1,1,1,0))
	GSM.emit_signal("change_menu_scene", menu_scene_id)
	for signal_name in additional_signals:
		GSM.emit_signal(signal_name)


func _on_UIButton_mouse_entered():
	tween_rotation(45, Color(1,1,1,1))


func _on_UIButton_mouse_exited():
	tween_rotation(0, Color(1,1,1,0))


func tween_rotation(new_rotation, new_mod):
	$IconAnimationTween.stop_all()
	$IconAnimationTween.interpolate_property($Icon, "rotation_degrees", $Icon.rotation_degrees, new_rotation, 1.0, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$IconAnimationTween.interpolate_property($Label, "modulate", $Label.modulate, new_mod, .25, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$IconAnimationTween.start()

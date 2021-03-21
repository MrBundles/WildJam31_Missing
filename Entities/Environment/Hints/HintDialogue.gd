tool
extends NinePatchRect

#exports
export var hint_id = 0
export var transition_duration = 1.0
export var start_hidden = true
export var hint_message = "" setget set_hint_message
export var box_color = Color(1,1,1,1) setget set_box_color
export var text_color = Color(1,1,1,1) setget set_text_color


func _ready():
	#connect signals
	GSM.connect("show_hint", self, "_on_show_hint")
	GSM.connect("hide_hint", self, "_on_hide_hint")
	
	$Label.text = hint_message
	
	if not Engine.editor_hint:
		if start_hidden:
			modulate.a = 0.0
		else:
			modulate.a = 1.0


func _on_show_hint(show_hint_id):
	if show_hint_id == hint_id:
		$Tween.interpolate_property(self, "modulate:a", modulate.a, 1.0,
		transition_duration,Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$Tween.start()


func _on_hide_hint(hide_hint_id):
	if hide_hint_id == hint_id:
		$Tween.interpolate_property(self, "modulate:a", modulate.a, 0.0,
		transition_duration,Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$Tween.start()


func set_hint_message(new_val):
	hint_message = new_val
	
	if has_node("Label"):
		$Label.text = hint_message


func set_text_color(new_val):
	text_color = new_val
	
	if has_node("Label"):
		$Label.self_modulate = text_color


func set_box_color(new_val):
	box_color = new_val
	
	self_modulate = box_color

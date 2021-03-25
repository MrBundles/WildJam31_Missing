tool
extends HBoxContainer
class_name GenericButton

#variables
export var button_text = "Button" setget set_button_text
export var game_scene_id = 0
export(GEM.MENU_SCENE_IDS) var menu_scene_id = GEM.MENU_SCENE_IDS.main
export var signal_name = ""
export var color_rect_hover_width = 128
export var color_rect_pressed_width = 192
export var rect_color = Color(1,1,1,1)
var init_x_pos = 0


func _ready():
	init_x_pos = rect_position.x
	$ColorRectLeft.color = rect_color
	$ColorRectRight.color = rect_color


func set_button_text(new_val):
	button_text = new_val
	
	if has_node("Button"):
		$Button.text = button_text


func _on_Button_mouse_entered():
	if not $Button.disabled:
		color_rect_tween(color_rect_hover_width)
		$MenuButtonHoverOn.play()


func _on_Button_mouse_exited():
	color_rect_tween(0)
	$MenuButtonHoverOff.play()


func color_rect_tween(new_width):
	$ColorRectTween.stop_all()
	$ColorRectTween.interpolate_property(self, "rect_size:x", rect_size.x, $Button.rect_min_size.x + new_width, .25, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$ColorRectTween.interpolate_property(self, "rect_position:x", rect_position.x, init_x_pos - new_width / 2, .25, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$ColorRectTween.start()


func _on_Button_button_down():
	color_rect_tween(color_rect_pressed_width)
	GSM.emit_signal(signal_name)
	GSM.emit_signal("change_scene", game_scene_id, menu_scene_id)
	$MenuButtonClick.play()


func _on_Button_button_up():
	color_rect_tween(color_rect_hover_width)

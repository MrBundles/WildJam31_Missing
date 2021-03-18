extends HBoxContainer

#signals
signal mute_button_pressed

#variables
export var color_rect_hover_width = 128
export var color_rect_pressed_width = 192
export var rect_color = Color(1,1,1,1)
var init_x_pos = 0
var bus_id
var mute_button_pressed = false setget set_mute_button_pressed


func _ready():
	init_x_pos = rect_position.x
	$ColorRectLeft.color = rect_color
	$ColorRectRight.color = rect_color


func _process(delta):
	if AudioServer.is_bus_mute(bus_id):
		$Button.text = "Unmute"
	else:
		$Button.text = "Mute"


func set_mute_button_pressed(new_val):
	mute_button_pressed = new_val
	
	if has_node("Button"):
		$Button.pressed = mute_button_pressed


func _on_Button_mouse_entered():
	color_rect_tween(color_rect_hover_width)


func _on_Button_mouse_exited():
	color_rect_tween(0)


func color_rect_tween(new_width):
	$ColorRectTween.stop_all()
	$ColorRectTween.interpolate_property(self, "rect_size:x", rect_size.x, $Button.rect_min_size.x + new_width, .25, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$ColorRectTween.interpolate_property(self, "rect_position:x", rect_position.x, init_x_pos - new_width / 2, .25, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$ColorRectTween.start()


func _on_Button_button_down():
	color_rect_tween(color_rect_pressed_width)


func _on_Button_button_up():
	color_rect_tween(color_rect_hover_width)


func _on_Button_toggled(button_pressed):
	emit_signal("mute_button_pressed", button_pressed)

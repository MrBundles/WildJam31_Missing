tool
extends GenericButton


func _on_Button_button_down():
	color_rect_tween(color_rect_pressed_width)
	GSM.emit_signal("change_game_scene", int(button_text))
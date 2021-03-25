tool
extends GenericButton


func _on_Button_button_down():
	color_rect_tween(color_rect_pressed_width)
	GSM.emit_signal("change_scene", game_scene_id, menu_scene_id)
	$MenuButtonClick.play()

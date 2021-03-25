extends GenericButton


func _process(delta):
	$Button.disabled = game_scene_id > GVM.highest_game_scene_beaten + 1 and not GVM.debug_mode


func _on_Button_button_down():
	color_rect_tween(color_rect_pressed_width)
	GSM.emit_signal("change_scene", game_scene_id, GEM.MENU_SCENE_IDS.empty)
	$MenuButtonClick.play()

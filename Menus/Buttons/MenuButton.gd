tool
extends GenericButton

#variables
export(GEM.MENU_SCENE_IDS) var menu_scene_id = GEM.MENU_SCENE_IDS.main


func _on_Button_button_down():
	color_rect_tween(color_rect_pressed_width)
	GSM.emit_signal("change_menu_scene", menu_scene_id)

extends Control

#variables
export(GEM.MENU_SCENE_IDS) var menu_scene_id = GEM.MENU_SCENE_IDS.main
var init_pos
var active_pos


func _ready():
	#connect signals
	GSM.connect("change_scene", self, "_on_change_scene")
	
	var viewport_width = get_viewport_rect().size.x
	var rect_width = rect_size.x
	
	if menu_scene_id == GEM.MENU_SCENE_IDS.main:
		init_pos = viewport_width * 0.3 - rect_width / 2
		active_pos = viewport_width * 0.5 - rect_width / 2
		rect_position.x = active_pos
	elif menu_scene_id == GEM.MENU_SCENE_IDS.empty:
		init_pos = viewport_width + rect_size.x
		active_pos = 0
		rect_position.x = init_pos
	elif menu_scene_id == GEM.MENU_SCENE_IDS.pause:
		init_pos = viewport_width + rect_size.x
		active_pos = viewport_width * 0.5 - rect_width / 2
		rect_position.x = init_pos
	elif menu_scene_id == GEM.MENU_SCENE_IDS.bugs:
		init_pos = viewport_width + rect_size.x
		active_pos = viewport_width * 0.5 - rect_width / 2
		rect_position.x = init_pos
	else:
		init_pos = viewport_width + rect_size.x
		active_pos = viewport_width * 0.7 - rect_width / 2
		rect_position.x = init_pos


func _on_change_scene(new_game_scene_id, new_menu_scene_id):
	if menu_scene_id == GEM.MENU_SCENE_IDS.empty:
		pass
	if menu_scene_id == GEM.MENU_SCENE_IDS.main and (new_menu_scene_id == GEM.MENU_SCENE_IDS.empty or new_menu_scene_id == GEM.MENU_SCENE_IDS.pause or new_menu_scene_id == GEM.MENU_SCENE_IDS.bugs):
		tween_pos(-rect_size.x * 2)
	elif menu_scene_id == new_menu_scene_id:
		tween_pos(active_pos)
	else:
		tween_pos(init_pos)


func tween_pos(new_pos):
	$MoveTween.stop_all()
	$MoveTween.interpolate_property(self, "rect_position:x", rect_position.x, new_pos, 1.0, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$MoveTween.start()


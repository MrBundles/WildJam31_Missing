extends Node2D

# signals --------------------------------------


# variables --------------------------------------
export var version : float = 0.4 setget set_version


# main functions --------------------------------------
func _ready():
	# connect signals
	GSM.connect("change_scene", self, "_on_change_scene")
	
	self.version = version


func _process(delta):
	pass


# helper functions --------------------------------------
func load_game_scene(game_scene_id):
	var game_scene_path = get_game_scene_path(game_scene_id)
	if game_scene_path != "":
		if GVM.previous_game_scene != GVM.game_scene:
			var game_scene_instance = load(game_scene_path).instance()
			game_scene_instance.global_position += GVM.scene_transition_offset
			$GameScenes.add_child(game_scene_instance)
			
			$SceneTransitionTween.stop_all()
			$SceneTransitionTween.remove_all()
			
			for child in $GameScenes.get_children():
				$SceneTransitionTween.interpolate_property(child, "global_position", child.global_position, child.global_position - GVM.scene_transition_offset, 1.0, Tween.TRANS_QUAD, Tween.EASE_OUT, 0.0)
		
			$SceneTransitionTween.start()
		else:
			clear_game_scenes()
			var game_scene_instance = load(game_scene_path).instance()
			$GameScenes.add_child(game_scene_instance)
		
		
	else:
		print("No game scene associated with provided game scene id")


func get_game_scene_path(game_scene_id):
	var game_scene_path = ""
	var path = "res://Scenes/Game_Scenes/"
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if str(game_scene_id).pad_zeros(2) in file_name:
				game_scene_path = path + file_name
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	return game_scene_path


func clear_game_scenes():
	for child in $GameScenes.get_children():
		child.queue_free()


# set/get functions --------------------------------------
func set_version(new_val):
	version = new_val
	GVM.version = version


# signal functions --------------------------------------
func _on_change_scene(game_scene_id, menu_scene_id):
	if game_scene_id != -1:
		load_game_scene(game_scene_id)


func _on_SceneTransitionTween_tween_all_completed():
	for i in range($GameScenes.get_child_count()):
		if i != 1:
			$GameScenes.get_child(i).queue_free()

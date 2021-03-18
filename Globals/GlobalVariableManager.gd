extends Node

# signals --------------------------------------


# variables --------------------------------------
var game_scene = 0 setget set_game_scene
var previous_game_scene = -1
var menu_scene = GEM.MENU_SCENE_IDS.main
var scene_transition_type = GEM.SCENE_TRANSITION_TYPES.up setget set_scene_transition_type
var scene_transition_offset = Vector2.ZERO
var scene_transition_in_progress = false


# main functions --------------------------------------
func _ready():
	# connect signals
	GSM.connect("change_game_scene", self, "_on_change_game_scene")
	GSM.connect("change_menu_scene", self, "_on_change_menu_scene")
	GSM.connect("reset_game_scene", self, "_on_reset_game_scene")
	GSM.connect("level_complete", self, "_on_level_complete")


func _process(delta):
	pass


# helper functions --------------------------------------


# set/get functions --------------------------------------
func set_game_scene(new_val):
	if game_scene != new_val:
		previous_game_scene = game_scene
		game_scene = new_val


func set_scene_transition_type(new_val):
	scene_transition_type = new_val
	
	var screen_size = get_viewport().get_visible_rect().size
	var additional_offset = 32
	
	match scene_transition_type:
		GEM.SCENE_TRANSITION_TYPES.up:
			scene_transition_offset = Vector2(0, -screen_size.y - additional_offset)
		GEM.SCENE_TRANSITION_TYPES.down:
			pass
		GEM.SCENE_TRANSITION_TYPES.left:
			pass
		GEM.SCENE_TRANSITION_TYPES.right:
			pass


# signal functions --------------------------------------
func _on_change_game_scene(game_scene_id):
	self.game_scene = game_scene_id
	
	if game_scene != 0:
		GSM.emit_signal("change_menu_scene", GEM.MENU_SCENE_IDS.empty)


func _on_change_menu_scene(menu_scene_id):
	menu_scene = menu_scene_id


func _on_reset_game_scene():
	GSM.emit_signal("change_game_scene", game_scene)


func _on_level_complete(new_scene_transition_type):
	self.game_scene += 1
	self.scene_transition_type = new_scene_transition_type
	GSM.emit_signal("change_game_scene", game_scene)

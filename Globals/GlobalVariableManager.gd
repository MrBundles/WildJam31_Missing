extends Node

# signals --------------------------------------


# variables --------------------------------------
var version : float = 0.0
var game_scene = 0 setget set_game_scene
var previous_game_scene = -1
var highest_game_scene_beaten = game_scene
var menu_scene = GEM.MENU_SCENE_IDS.main
var scene_transition_type = GEM.SCENE_TRANSITION_TYPES.up setget set_scene_transition_type
var scene_transition_offset = Vector2.ZERO


# main functions --------------------------------------
func _ready():
	# connect signals
	GSM.connect("change_scene", self, "_on_change_scene")
	GSM.connect("reset_game_scene", self, "_on_reset_game_scene")
	GSM.connect("cable_charged", self, "_on_cable_charged")


func _process(delta):
	pass


# helper functions --------------------------------------


# set/get functions --------------------------------------
func set_game_scene(new_val):
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
			scene_transition_offset = Vector2(0, screen_size.y + additional_offset)
		GEM.SCENE_TRANSITION_TYPES.left:
			scene_transition_offset = Vector2(-screen_size.x - additional_offset, 0)
		GEM.SCENE_TRANSITION_TYPES.right:
			scene_transition_offset = Vector2(screen_size.x + additional_offset, 0)


# signal functions --------------------------------------
func _on_change_scene(game_scene_id, menu_scene_id):
	if game_scene_id != -1:
		self.game_scene = game_scene_id
	self.menu_scene = menu_scene_id
	
	match menu_scene_id:
		GEM.MENU_SCENE_IDS.main:
			get_tree().paused = false
		GEM.MENU_SCENE_IDS.level_select:
			get_tree().paused = false
		GEM.MENU_SCENE_IDS.settings:
			get_tree().paused = false
		GEM.MENU_SCENE_IDS.credits:
			get_tree().paused = false
		GEM.MENU_SCENE_IDS.pause:
			get_tree().paused = true
		GEM.MENU_SCENE_IDS.quit:
			get_tree().quit()
		GEM.MENU_SCENE_IDS.empty:
			get_tree().paused = false
		GEM.MENU_SCENE_IDS.bugs:
			get_tree().paused = true


func _on_reset_game_scene():
	GSM.emit_signal("change_scene", game_scene, menu_scene)


func _on_cable_charged(cable_type, cable_id, cable_charged, _scene_transition_type):
	if cable_type == GEM.CABLE_TYPES.end:
		self.scene_transition_type = _scene_transition_type
		GSM.emit_signal("change_scene", game_scene + 1, menu_scene)
		
		if game_scene > highest_game_scene_beaten:
			highest_game_scene_beaten = game_scene

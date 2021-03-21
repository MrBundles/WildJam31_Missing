extends Node

# signals --------------------------------------
signal socket_plugged		#socket_type, socket_id, socket_plugged
signal cable_charged		#cable_type, cable_id, cable_charged, scene_transition_type
signal terminal_on			#terminal_id, terminal_on

signal change_scene			#game_scene_id, menu_scene_id
signal reset_game_scene

signal send_bug_report

signal change_bus_volume	#bus_id, new_val
signal change_bus_mute		#bus_id, new_val
signal bus_mute_changed		#bus_id, new_val
signal bus_volume_changed	#bus_id, new_val

signal show_hint			#hint_id
signal hide_hint			#hint_id

signal camera_shake			#camera_shake

# variables --------------------------------------


# main functions --------------------------------------
func _ready():
	# connect signals
	
	pass


func _process(delta):
	pass


# helper functions --------------------------------------


# set/get functions --------------------------------------


# signal functions --------------------------------------

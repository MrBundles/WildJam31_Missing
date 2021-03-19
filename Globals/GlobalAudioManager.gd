extends Node

# signals --------------------------------------


# variables --------------------------------------


# main functions --------------------------------------
func _ready():
	# connect signals
	GSM.connect("change_bus_volume", self, "change_bus_volume")
	GSM.connect("change_bus_mute", self, "change_bus_mute")


func _process(delta):
	pass


# helper functions --------------------------------------


# set/get functions --------------------------------------


# signal functions --------------------------------------
func change_bus_volume(bus_id, new_val):
	AudioServer.set_bus_volume_db(bus_id, new_val)
	GSM.emit_signal("bus_volume_changed", bus_id, new_val)


func change_bus_mute(bus_id, new_val):
	AudioServer.set_bus_mute(bus_id, new_val)
	GSM.emit_signal("bus_mute_changed", bus_id, new_val)

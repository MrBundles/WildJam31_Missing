extends Node

# signals --------------------------------------


# variables --------------------------------------


# main functions --------------------------------------
func _ready():
	# connect signals
	
	init_version_label()


func _process(delta):
	pass


# helper functions --------------------------------------
func init_version_label():
	$Version.text = "Rev " + str(GVM.version).pad_decimals(1)


# set/get functions --------------------------------------


# signal functions --------------------------------------

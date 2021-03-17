extends RigidBody2D
class_name Interactable
#Interactables will be activated/deactivated by an associated terminal
#Each Interactible will require the following to operate
#	It will need to be of type RigidBody2D
#	It will need its own set_active function for any custom  transitions to and from an active state


# signals --------------------------------------


# variables --------------------------------------
export var interactable_id = 0
export var active = false setget set_active
export var active_color = Color(1,1,1,1)
export var inactive_color = Color(1,1,1,1)

export(GEM.I_MODES) var i_mode = GEM.I_MODES.manual
export var auto_speed = Vector2.ZERO
export var speed = Vector2.ZERO
export var speed_max = Vector2.ZERO
export var accel = Vector2.ZERO
export var decel = Vector2.ZERO
export(GEM.ORIENTATIONS) var orientation = GEM.ORIENTATIONS.horizontal


# main functions --------------------------------------
func _ready():
	# connect signals
	GSM.connect("terminal_on", self, "_on_terminal_on")


func _process(delta):
	pass


# helper functions --------------------------------------


# set/get functions --------------------------------------
func set_active(new_val):
	active = new_val


# signal functions --------------------------------------
func _on_terminal_on(terminal_id, terminal_on):
	if interactable_id == terminal_id:
		self.active = terminal_on

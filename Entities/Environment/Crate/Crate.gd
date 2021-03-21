tool
extends RigidBody2D

# signals --------------------------------------


# variables --------------------------------------
export var size = Vector2(4,4) setget set_size
var size_mult = Vector2(64,64)
export var color = Color(1,1,1,1) setget set_color


# main functions --------------------------------------
func _ready():
	# connect signals
	
	self.size = size
	self.color = color


func _process(delta):
	if not Engine.editor_hint:
		if GVM.scene_in_transition:
			mode = RigidBody2D.MODE_STATIC
		else:
			mode = RigidBody2D.MODE_RIGID


# helper functions --------------------------------------


# set/get functions --------------------------------------
func set_size(new_val):
	size = new_val
	
	if has_node("CollisionShape2D"):
		$CollisionShape2D.shape.extents = size * size_mult / Vector2(2,2)
	
	if has_node("NinePatchRect"):
		$NinePatchRect.rect_position = -size * size_mult / Vector2(2,2)
		$NinePatchRect.rect_size = size * size_mult


func set_color(new_val):
	color = new_val
	
	modulate = color


# signal functions --------------------------------------

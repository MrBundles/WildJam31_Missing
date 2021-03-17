extends TileMap

# signals --------------------------------------


# variables --------------------------------------
export(Array, PackedScene) var interactable_array

export var interactable_id = 0 setget set_interactable_id
export var active = false setget set_active
export var active_color = Color(1,1,1,1) setget set_active_color
export var inactive_color = Color(1,1,1,1) setget set_inactive_color
export(GEM.I_MODES) var i_mode = GEM.I_MODES.manual setget set_i_mode
export var auto_speed = Vector2.ZERO setget set_auto_speed
export var speed = Vector2.ZERO setget set_speed
export var speed_max = Vector2.ZERO setget set_speed_max
export var accel = Vector2.ZERO setget set_accel
export var decel = Vector2.ZERO setget set_decel
export(GEM.ORIENTATIONS) var orientation = GEM.ORIENTATIONS.horizontal setget set_orientation


# main functions --------------------------------------
func _ready():
	# connect signals
	
	parse_cells()


func _process(delta):
	pass


# helper functions --------------------------------------
func parse_cells():
	var cell_offset = Vector2(32,32)
	for cell_pos in get_used_cells():
		var cell_id = get_cell(cell_pos.x, cell_pos.y)
		
		var interactable_instance = interactable_array[cell_id].instance()
		interactable_instance.global_position = map_to_world(cell_pos) + cell_offset
		interactable_instance.interactable_id = interactable_id
		interactable_instance.active = active
		interactable_instance.active_color = active_color
		interactable_instance.inactive_color = inactive_color
		interactable_instance.i_mode = i_mode
		interactable_instance.auto_speed = auto_speed
		interactable_instance.speed = speed
		interactable_instance.speed_max = speed_max
		interactable_instance.accel = accel
		interactable_instance.decel = decel
		interactable_instance.orientation = orientation
		add_child(interactable_instance)
	
	clear()


# set/get functions --------------------------------------
func set_interactable_id(new_val):
	interactable_id = new_val
	for child in get_children():
		child.interactable_id = interactable_id


func set_active(new_val):
	active = new_val
	for child in get_children():
		child.active = active


func set_active_color(new_val):
	active_color = new_val
	for child in get_children():
		child.active_color = active_color


func set_inactive_color(new_val):
	inactive_color = new_val
	for child in get_children():
		child.inactive_color = inactive_color


func set_i_mode(new_val):
	i_mode = new_val
	for child in get_children():
		child.i_mode = i_mode


func set_auto_speed(new_val):
	auto_speed = new_val
	for child in get_children():
		child.auto_speed = auto_speed


func set_speed(new_val):
	speed = new_val
	for child in get_children():
		child.speed = speed


func set_speed_max(new_val):
	speed_max = new_val
	for child in get_children():
		child.speed_max = speed_max


func set_accel(new_val):
	accel = new_val
	for child in get_children():
		child.accel = accel


func set_decel(new_val):
	decel = new_val
	for child in get_children():
		child.decel = decel


func set_orientation(new_val):
	orientation = new_val
	for child in get_children():
		child.orientation = orientation

# signal functions --------------------------------------

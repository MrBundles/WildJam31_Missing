extends CanvasLayer


func _ready():
	$BackgroundCPUParticles2D.global_position = get_viewport().get_visible_rect().size / Vector2(2,2)
	$BackgroundCPUParticles2D.emission_rect_extents = get_viewport().get_visible_rect().size

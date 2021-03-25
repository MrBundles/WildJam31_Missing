extends CanvasLayer


func _ready():
	#connect signals
	GSM.connect("camera_shake", self, "_on_camera_shake")
	
	$BackgroundCPUParticles2D.global_position = get_viewport().get_visible_rect().size / Vector2(2,2)
	$DebrisCPUParticles2D.global_position = Vector2(get_viewport().get_visible_rect().size.x / 2, -500)
	$BackgroundCPUParticles2D.emission_rect_extents = get_viewport().get_visible_rect().size
	$DebrisCPUParticles2D.emission_rect_extents = Vector2(get_viewport().get_visible_rect().size.x, 64)


func _on_camera_shake(camera_shake):
	print("shaking")
	$DebrisCPUParticles2D.emitting = true
	$PlantExplosion.play()

extends Interactable

# signals --------------------------------------


# variables --------------------------------------
var noise_tex = NoiseTexture.new()

# main functions --------------------------------------
func _ready():
	# connect signals
	
	init_noise()


func _process(delta):
	pass


# helper functions --------------------------------------
func init_noise():
	var noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 3
	noise.period = 64.0
	noise.persistence = 0.5
	noise.lacunarity = 2
	
	noise_tex.noise = noise
	
	$WindSprite.material.set_shader_param("noise_tex", noise_tex)


# set/get functions --------------------------------------


# signal functions --------------------------------------

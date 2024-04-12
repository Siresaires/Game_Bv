extends Camera2D

var startshake = false
var shakeintensity = 0
var shakedamping = 0

onready var shaketime = $Screen_shake_time

func _ready():
	Global.camera = self

	
func _process(delta):
	if startshake == true:
		offset.x = rand_range(-1, 1) * shakeintensity
		offset.y = rand_range(-1, 1) * shakeintensity
		shakeintensity = lerp(shakeintensity, 0, shakedamping)
	else:
		offset = Vector2(0, 0)

func screen_shake(intensity, duration, dampening):
	shakeintensity = intensity
	shaketime.wait_time = duration
	shakedamping = dampening
	startshake = true


func _on_Screen_shake_time_timeout():
	startshake = false

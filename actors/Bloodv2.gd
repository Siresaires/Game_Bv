extends Area2D

var cpuParticles: CPUParticles2D

func _ready():
	cpuParticles = $CPUParticles2D  # Replace "CPUParticles" with the actual name of your CPU particle node
	



func _on_Freeze_blood_timeout():
	cpuParticles.set_process(false)
	cpuParticles.set_physics_process(false)
	cpuParticles.set_process_input(false)
	cpuParticles.set_process_internal(false)
	cpuParticles.set_process_unhandled_input(false)
	cpuParticles.set_process_unhandled_key_input(false)



func _on_Bloodv2_body_entered(body):
	queue_free()

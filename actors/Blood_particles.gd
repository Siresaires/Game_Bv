extends CPUParticles2D



func _on_Freeze_blood_timeout():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_internal(false)
	set_process_unhandled_input(false)
	set_process_unhandled_key_input(false)






func _on_Area2D_body_entered(body):
	pass

extends Area2D

signal Is_Active



func _on_Button_body_entered(body):
	if body.name == "Player":
		$Pepito.play("New Anim (2)")
		yield($Pepito, "animation_finished")
		print("i did the thing and is not my fault")
		emit_signal("Is_Active")
	else:
		$Pepito.play("New Anim")

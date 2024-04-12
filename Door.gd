extends Area2D





func _on_Button_Is_Active():
	$AnimationPlayer.play("opening")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("opened")

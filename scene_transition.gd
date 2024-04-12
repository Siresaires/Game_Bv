extends CanvasLayer



func change_scene(target: String) -> void:
	$Animationplayer.play("disolve")
	yield($Animationplayer, "animation_finished")
	get_tree().change_scene(target)
	$Animationplayer.play_backwards("disolve")

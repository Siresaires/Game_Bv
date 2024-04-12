extends Area2D


func _ready() -> void:
	$AnimationPlayer.play("RESET")


func _on_hiddenArea_body_entered(body):
	if body.name == "Player":
		$AnimationPlayer.play("revealed")
		yield($AnimationPlayer, "animation_finished")


func _on_hiddenArea_body_exited(body):
	if body.name == "Player":
		$AnimationPlayer.play("fade back")
		yield($AnimationPlayer, "animation_finished")
		$AnimationPlayer.play("hidden")

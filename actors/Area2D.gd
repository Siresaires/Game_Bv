extends Area2D

const WALL_GROUP = "Walls"




func _on_Area2D_body_entered(body):
	if body.is_in_group(WALL_GROUP):
		queue_free() # Remove the Blood particle or specific blood splat


extends Node2D

var Smoketrail = preload("res://Scenes/SmokeTrail.tscn")

func handle_bullet_spawned(bullet: Bullet, position: Vector2, direction: Vector2):
	add_child(bullet)
	bullet.global_position = position
	bullet.set_direction(direction)


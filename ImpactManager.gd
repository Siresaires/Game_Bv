extends Node2D


const BLOOD_PARTICLES = preload("res://actors/Bloodv2.tscn")

func _ready():
	GlobalSignals.connect("bullet_impacted", self, "handle_bullet_impacted")
	GlobalSignals.connect("blood", self, "handle_enemy_died")


func handle_bullet_impacted(position: Vector2, direction: Vector2):
	var blood_particles_instance = BLOOD_PARTICLES.instance()
	call_deferred("add_child", blood_particles_instance)
	call_deferred("set_blood_particles_properties", blood_particles_instance, position, direction.angle())



func handle_enemy_died(position: Vector2, direction: Vector2):
	var blood_particles_instance = BLOOD_PARTICLES.instance()
	call_deferred("add_child", blood_particles_instance)
	call_deferred("set_blood_particles_properties", blood_particles_instance, position, direction.angle())

func set_blood_particles_properties(blood_particles_instance: Node2D, position: Vector2, rotation: float):
	blood_particles_instance.global_position = position
	blood_particles_instance.global_rotation = rotation




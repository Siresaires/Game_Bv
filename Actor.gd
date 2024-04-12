extends KinematicBody2D
class_name Actor


signal died



onready var health_stat = $Health
onready var ai = $Ai
onready var weapon = $Weapon
onready var team = $Team
onready var sound = $Death
onready var score_value = $Score

const bullet = preload("res://Bullet.tscn")

const DEAD_ENEMY = preload("res://actors/DeadEnemy.tscn")
var camera: Camera2D

var velocity = Vector2()

var explosion_pitch = 1
var explosion_volume = -25


export (int) var speed = 100

func move_towards(target_direction: Vector2):
	velocity = target_direction.normalized() * speed


func _ready():
	ai.initialize(self, weapon, team.team)
	camera = get_node("/root/Main/Camera2D")


#func _on_player_dashed():
	#var player = get_node_or_null("/root/World/Player")
	#if player && player.is_dashing() && global_position.distance_to(player.global_position) < 50:
		# Check if player is facing towards enemy
		#var player_dir = player.get_global_transform().basis.xform(Vector3(1, 0, 0))
		#var enemy_dir = global_position.direction_to(player.global_position)
		#if player_dir.dot(enemy_dir) > 0.5:
			#die()
			#print("Player dashed and hit enemy!")



func rotate_toward(location: Vector2):
	rotation = lerp_angle(rotation, global_position.direction_to(location).angle(), 0.1)



func velocity_toward(location: Vector2) -> Vector2:
	return global_position.direction_to(location) * speed



func has_reached_position(location: Vector2) -> bool:
	return global_position.distance_to(location) < 5


func get_team() -> int:
	return team.team


func handle_hit(var scoring):
	
	if scoring:
		Global.update_score(score_value.score)
	
	health_stat.health -= 100

	if health_stat.health <= 0:
		var death = DEAD_ENEMY.instance()
		get_parent().add_child(death)
		death.global_position = global_position
		death.start(scoring)
		Global.camera.screen_shake(80, 60, 0.05) #27, 5, 0.05
		_play_explosion_sound()
		emit_signal("died")
		
		queue_free()
		#die()

#func die():#!!!!!
	#var direction = Vector2.LEFT
	#Global.camera.screen_shake(27, 5, 0.05)
	#GlobalSignals.emit_signal("blood", global_position, direction)
	#emit_signal("died")
	#_play_explosion_sound()
	#queue_free()

func _play_explosion_sound():
	var explosion_sound = AudioStreamPlayer.new()
	explosion_sound.stream = load("res://assets/Audio/Deathsound.wav")
	explosion_sound.volume_db = explosion_volume
	explosion_sound.pitch_scale = explosion_pitch
	get_parent().add_child(explosion_sound)
	explosion_sound.play(0)

	




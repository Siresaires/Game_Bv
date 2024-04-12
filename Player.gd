extends KinematicBody2D
class_name Player

signal dash_ended

signal player_health_changed(new_health)
signal died
signal bullet_time
signal win
signal time_over
signal Bullet_time_delay
signal bar_duration
signal toggle_shooting


export (int) var speed = 250


var slow_mode_speed = 700

var current_speed = speed
const bullet_time_delay = 0.2
const bullet_time_duration = 0.6

const dash_speed = 1700
const dash_duration = 0.2

onready var team = $Team
onready var weapon_manager = $WeaponManager
onready var health_stat = $Health
onready var camera_transform = $CameraTransform
onready var light_transform = $LightTransform
onready var dash = $Dash
onready var sprite = $Sprite
onready var dash_hurtbox = $DashHurtbox

var direction = Vector2()


onready var delay_timer = $Timer2
onready var duration_timer = $Timer
var can_bullet_time = true


onready var fulltime = 0.7 + 0.8

var is_dashing = false

var bullet_time = true
#bullet_time
export (int) var bullet_time_factor = 0.1

var explosion_pitch = 1.5
var explosion_volume = -35


var cooldown_progress: float = 0.0 

func _ready():
	weapon_manager.initialize(team.team)
	weapon_manager.connect("toggle_shooting", self, "_on_weapon_manager_toggle_shooting")
	weapon_manager.connect("not_bullet_time", self, "not trigger")



func _on_dialogue_toggle_shooting(active: bool):
	weapon_manager.set_shooting_active(active)

func _physics_process(delta: float) -> void:
	var movement_direction := Vector2.ZERO
	var is_moving := false
	
	
	if Input.is_action_pressed("up"):
		movement_direction.y = -1
		is_moving = true
		$Walk.pitch_scale = rand_range(0.8, 1.2)
		$Walk.play()
	if Input.is_action_pressed("down"):
		movement_direction.y = 1
		is_moving = true
		$Walk.pitch_scale = rand_range(0.8, 1.2)
		$Walk.play()
	if Input.is_action_pressed("left"):
		movement_direction.x = -1
		is_moving = true
		$Walk.pitch_scale = rand_range(0.8, 1.2)
		$Walk.play()
	if Input.is_action_pressed("right"):
		movement_direction.x = 1
		is_moving = true
		$Walk.pitch_scale = rand_range(0.8, 1.2)
		$Walk.play()
	#if Input.is_action_just_pressed("dash") && !is_bullet_time() && can_bullet_time: #&& !dash.is_dashing() && dash.can_dash:
			#start_bullet_time(bullet_time_duration)
		#bullet_time = !bullet_time
		
		#bullet_time = !bullet_time
		#is_dashing = true
		#_play_explosion_sound()
	
	

		#dash.start_dash(sprite, dash_duration, movement_direction)
	
	movement_direction = movement_direction.normalized()
	move_and_slide (movement_direction * current_speed)
	
	
	
	look_at(get_global_mouse_position())




func set_camera_transform(camera_path: NodePath):
	camera_transform.remote_path = camera_path
	
	
func set_light_transform(light_path: NodePath):
	light_transform.remote_path = light_path




func get_team() -> int:
	return team.team




func handle_hit(var _nothing):
	if is_dashing: return
	health_stat.health -= 100
	emit_signal("player_health_changed", health_stat.health)
	if health_stat.health <= 0:
		die()


func die():
	emit_signal("time_over")
	EngineEx.time_scale = 1
	emit_signal("died")
	Global.save_score()
	queue_free()

func win():
	emit_signal("win")
	queue_free()


func _on_DashHurtbox_body_entered(body):
	if body.is_in_group("enemy") and is_dashing:
		body.handle_hit()
		#frameFreeze(0.05, 1.0)

func set_active(active):
	set_physics_process(active)
	set_process(active)
	set_process_input(active)


func _play_explosion_sound():
	var explosion_sound = AudioStreamPlayer.new()
	explosion_sound.stream = load("res://assets/Audio/Dash.wav")
	explosion_sound.volume_db = explosion_volume
	explosion_sound.pitch_scale = explosion_pitch
	get_parent().add_child(explosion_sound)
	explosion_sound.play(0)

func start_bullet_time(duration):
	#var fulltime = duration_timer + delay_timer
	emit_signal("bullet_time")#nothing to do with the bar of bullet time, its just an effect
	#givin the signal and the timer that it delays 1 second before the player can press it again
	EngineEx.time_scale = 0.2
	current_speed = slow_mode_speed
	duration_timer.start()
	emit_signal("bar_duration", fulltime)



func is_bullet_time():
	return !duration_timer.is_stopped()


func _on_Area2D_area_entered(area: Area2D) -> void: #The automatic detector that trigers bullet time when player gets close to death
	if area.is_in_group("Bullet") && !area.is_in_group("player_bullets") && !is_bullet_time() && can_bullet_time:
		start_bullet_time(bullet_time_duration)
		

func end_bullet_time(): #this has to do to cooldown the dash
	
	emit_signal("time_over")
	can_bullet_time = false
	EngineEx.time_scale = 1
	current_speed = speed
	delay_timer.start()
	#emit_signal("Bullet_time_delay", delay_timer)
	


func _on_Timer_timeout() -> void:
	end_bullet_time()


func _on_Timer2_timeout() -> void:
	can_bullet_time = true


func _walk():
	var explosion_sound = AudioStreamPlayer.new()
	explosion_sound.stream = load("res://assets/Audio/Walk.wav")
	explosion_sound.volume_db = explosion_volume
	explosion_sound.pitch_scale = explosion_pitch
	get_parent().add_child(explosion_sound)
	explosion_sound.play(0)

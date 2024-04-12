extends Node2D
class_name Ai


signal state_changed(new_state)


enum State {
	PATROL,
	ENGAGE,
	ADVANCE
}


export (bool) var should_draw_path_line := false


onready var patrol_timer = $PatrolTimer
onready var path_line = $PathLine


var current_state: int = -1 setget set_state
var actor: Actor = null
var target: KinematicBody2D = null
var weapon: Weapon = null
var team: int = -1

# PATROL STATE
var origin: Vector2 = Vector2.ZERO
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached: bool = false
var actor_velocity: Vector2 = Vector2.ZERO

#Advance state is here :3
var next_base: Vector2 = Vector2.ZERO
var player_last_position: Vector2 = Vector2.ZERO

var pathfinding: Pathfinding

func _ready():
	set_state(State.PATROL)
	path_line.visible = should_draw_path_line



func _physics_process(delta):
	path_line.global_rotation = 0

	match current_state:
		State.PATROL:
			if not patrol_location_reached:
				var path = pathfinding.get_new_path(global_position, patrol_location)
				if path.size() > 1:
					actor_velocity = actor.velocity_toward(path [1])
					actor.rotate_toward(path [1])
					actor.move_and_slide(actor_velocity)
					set_path_line(path)
				else:
					patrol_location_reached = true
					actor_velocity = Vector2.ZERO
					patrol_timer.start()
					path_line.clear_points()
		State.ENGAGE:
			if target != null and weapon != null:
				actor.rotate_toward(target.global_position)
				var angle_to_player = actor.global_position.direction_to(target.global_position).angle()
				if abs(actor.rotation - angle_to_player) < 0.8:
					weapon.shoot()
				#similar line
				#if abs(actor.global_position.angle_to(target.global_position)) < 0.04:
					#weapon shoot()
			else:
				print("In the engage state but no weapon/target")
		State.ADVANCE:
			if next_base != Vector2.ZERO:
				var path = pathfinding.get_new_path(global_position, next_base)
				if path.size() > 1:
					var target_point = path[path.size() - 1]
					actor_velocity = actor.velocity_toward(target_point)
					actor.rotate_toward(target_point)
					actor.move_and_slide(actor_velocity)
					set_path_line(path)
				else:
					# No valid path found, fallback to direct movement
					var direction = (next_base - global_position).normalized()
					actor_velocity = direction * actor.speed
					actor.rotate_toward(next_base)
					actor.move_and_slide(actor_velocity)
					set_path_line([global_position, next_base])  # Display a direct line to the target
			else:
				set_state(State.PATROL)
		_:
			print ("Error: found a state for our enemy that should not exist")


func initialize(actor: KinematicBody2D, weapon: Weapon, team: int):
	self.actor = actor
	self.weapon = weapon
	self.team = team

	weapon.connect("weapon_out_of_ammo", self, "handle_reload")
	
	
func set_path_line(points: Array):
	if not should_draw_path_line:
		return
		
	var local_points := []
	for point in points:
		if point == points[0]:
			local_points.append(Vector2.ZERO)
		else:
			local_points.append(point - global_position)
	
	path_line.points = local_points


func set_state(new_state: int):
	if new_state == current_state:
		return
		
		
		
	if new_state == State.PATROL:
		origin = global_position
		patrol_timer.start()
		patrol_location_reached = true
	
	elif new_state == State.ADVANCE:
		if actor.has_reached_position(next_base):
			set_state(State.PATROL)
	


	current_state = new_state
	emit_signal("state_changed", current_state)


func handle_reload():
	weapon.start_reload()


func _on_PatrolTimer_timeout():
	actor_velocity = Vector2.ZERO
	var patrol_range = 150
	var random_x = rand_range(-patrol_range, patrol_range)
	var random_y = rand_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false

#Need it dumbass >:v
func _on_DetectionZone_body_entered(body):
	if body.has_method("get_team") and body.get_team() != team:
		next_base = Vector2.ZERO
		print("state engage")
		set_state(State.ENGAGE)
		target = body
		
		


func _on_DetectionZone_body_exited(body):
	if target and body == target:
		player_last_position = body.global_position
		print("Now I know player last position:", player_last_position)
		set_state(State.ADVANCE)
		next_base = player_last_position
		target = null


#add in func detection a collision detect if the enemy is facing towards that wall and if it is then change the set engage to advance

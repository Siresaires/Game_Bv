extends Area2D
class_name Bullet


export (int) var speed = 700 #it is velocity


onready var kill_timer = $KillTimer
onready var smoketrail = $SmokeTrail
onready var explosion = $AnimationPlayer
export var normal_gun = true

var bullet_team: int = -1
#signal enemy_hit(body) !!! warning

var direction := Vector2.RIGHT
var num_bounces = 0
var max_bounces = 3
const MAX_BOUNCES = 10
var bounce_speed_multiplier = 0.9

var wall_map: Node2D = null
var wall_positions: Dictionary = {}


var enemy_map: Node2D = null
var enemy_positions: Dictionary = {}


func _ready():
	kill_timer.start()
	wall_map = get_tree().root.get_node("Main/WallMap")
	#self.connect("wall_map_ready", self, "_on_wall_map_ready")
	#func _on_wall_map_ready(wall_positions_received: Dictionary):
	#wall_positions = wall_positions_received

func _physics_process(delta: float) -> void:
		# Check if the bullet is queued for freeing, and return early if it is
	if direction != Vector2.ZERO:
		if normal_gun:
			var velocity = direction * speed * delta
			if is_instance_valid(smoketrail):
				smoketrail.add_point(global_position)
			direction = direction.rotated(rand_range(-0.0, 0.0))
			global_position += velocity
		else:
			var velocity = direction * speed * delta
			if is_instance_valid(smoketrail):
				smoketrail.add_point(global_position)
			direction = direction.rotated(rand_range(-0.1, 0.1)) #The wiggly thing :D
			global_position += velocity



#be careful with the direction of physics and vector right
func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()

func _on_KillTimer_timeout():
	queue_free()

func _on_Bullet_body_entered(body):
	if body.has_method("handle_hit"):
		GlobalSignals.emit_signal("bullet_impacted", global_position, direction)
		body.handle_hit(true)
		if is_instance_valid(smoketrail):
			smoketrail.stop()
		explosion.play("explosion")
		queue_free()
		# Set the enemy as the picked_enemy
	
	else:
		#add a bouncing for player, when input dash then bounce bullets from player and kills enemies...
		if body.get_collision_layer_bit(1): # Assuming the walls are on collision layer 1
			if is_in_group("player_bullets"):
				remove_from_group("player_bullets")
				add_to_group("enemy_bullets")
			
			
			var wall_normal = get_collision_normal(body)
			#print("Wall Normal:", wall_normal)
			
			#print("Collision detected with Wall.")
			#print("Wall Normal:", wall_normal)
			
			# Add random rotation here (similar to the code in _physics_process)
			wall_normal = wall_normal.rotated(rand_range(-0.1, 0.1))
			
			
			#!Warning, there is a glitch on the bouncing, we only need to make this better
			#!!!!!!!!!!!!!!!
			direction = direction - 2 * direction.dot(wall_normal) * wall_normal
			direction = direction.reflect(wall_normal)
			direction = direction.normalized()
			#print("Updated Direction:", direction)
			num_bounces += 1
			

			# Optional: Add some visual effects for the bounce (e.g., particle effects)

			# Adjust the rotation of the bullet based on the new direction
			rotation += direction.angle()

			# Optional: Play a sound effect for the bounce

			# Decrease bullet speed after each bounce
			speed *= bounce_speed_multiplier
			


func get_collision_normal(body):
		# Calculate the collision normal based on the body's position
		var walls_tilemap = wall_map.get_node("Walls")
		var local_position = walls_tilemap.world_to_map(body.position)#walls_tilemap.world_to_map(body.position)
		
			# Add debug prints
		#print("Local Position:", local_position)
		
		#.cell_size
		
		var tile_size = wall_map.get_node("Walls").cell_size
		var tile_id = wall_map.get_node("Walls").get_cellv(local_position)#wall_map.get_node("Walls").get_cellv(local_position)
		
			# Add debug print
		#print("Tile ID:", tile_id)
		
		var tile_center = (local_position + Vector2(0.5, 0.5)) * tile_size
		

		var neighbors = [
			Vector2(1, 0),
			Vector2(-1, 0),
			Vector2(0, 1),
			Vector2(0, -1)
		]

		var total_normal = Vector2.ZERO
		var valid_neighbors = 0

		for neighbor in neighbors:
			var neighbor_pos = local_position + neighbor
			var neighbor_id = wall_map.get_node("Walls").get_cellv(neighbor_pos)
			
			if neighbor_id == tile_id:
				var neighbor_center = (neighbor_pos + Vector2(0.5, 0.5)) * tile_size
				var normal = (neighbor_center - tile_center).normalized()
				total_normal += normal
				valid_neighbors += 1

		if valid_neighbors > 0:
			var average_normal = total_normal / valid_neighbors
			return average_normal.normalized()
		else:
			# Return a default normal if no valid neighbors were found
			return Vector2.RIGHT


extends Node2D




export (Team.TeamName) var team_name = Team.TeamName.NEUTRAL
export (PackedScene) var unit = null
export (int) var max_units_alive = 17



var respawn_points: Array = []
var next_spawn_to_use: int = 0
var pathfinding: Pathfinding


onready var team = $Team
onready var unit_container = $UnitContainer
onready var respawn_timer = $RespawnTimer


func initialize(respawn_points: Array, pathfinding: Pathfinding):

		
	team.team = team_name
	self.pathfinding = pathfinding
	
	self.respawn_points = respawn_points
	for respawn in respawn_points:
		spawn_unit(respawn.global_position)
	


func spawn_unit(spawn_location: Vector2):
	var unit_instance = unit.instance()
	unit_container.add_child(unit_instance)
	unit_instance.global_position = spawn_location
	unit_instance.connect("died", self, "handle_unit_death")
	unit_instance.ai.pathfinding = pathfinding


func handle_unit_death():
	if respawn_timer.is_stopped() and unit_container.get_children().size() < max_units_alive:
		respawn_timer.start()


func _on_RespawnTimer_timeout():
	var respawn = respawn_points[next_spawn_to_use]
	spawn_unit(respawn.global_position)
	next_spawn_to_use += 1
	if next_spawn_to_use == respawn_points.size():
		next_spawn_to_use = 0
	
	if unit_container.get_children().size() < max_units_alive:
		respawn_timer.start()

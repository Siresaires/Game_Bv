extends Area2D
class_name ObjectiveNPC


signal base_captured(new_team)


export (Color) var neutral_color = Color (1, 1, 1)
export (Color) var player_color = Color(0.182861, 0.417969, 0.307762)
export (Color) var enemy_color = Color(0.129412, 0.156863, 0.333333)


var player_unit_count: int = 0
var enemy_unit_count: int = 0
var team_to_capture: int = Team.TeamName.NEUTRAL


onready var collision_shape = $CollisionShape2D
onready var team = $Team
onready var capture_timer = $CaptureTimer
onready var sprite = $Sprite


func get_random_position_whithin_capture_radius() -> Vector2:
	var extents = collision_shape.shape.extents
	var top_left = collision_shape.global_position - (extents / 2)
	
	var x = rand_range(top_left.x, top_left.x + extents.x)
	var y = rand_range(top_left.y, top_left.y + extents.y)
	
	return Vector2(x, y)

#Remember to add var to hide Sprite, use the Weapon example and remember that we do this beacuse is going to be an objective for the npc not the player
func _ready():
	sprite.hide()

func _on_ObjectiveNPC_body_entered(body):
	if body.has_method("get_team"):
		var body_team = body.get_team()
		
		if body_team == Team.TeamName.ENEMY:
			enemy_unit_count += 1
		elif body_team == Team.TeamName.PLAYER:
			player_unit_count += 1
		
		check_whether_base_can_be_captured()


func _on_ObjectiveNPC_body_exited(body):
	if body.has_method("get_team"):
		var body_team = body.get_team()
		
		if body_team == Team.TeamName.ENEMY:
			enemy_unit_count -= 1
		elif body_team == Team.TeamName.PLAYER:
			player_unit_count -= 1
		
		check_whether_base_can_be_captured()


func check_whether_base_can_be_captured():
	var majority_team = get_team_with_majority()

	if majority_team == Team.TeamName.NEUTRAL:
		print("Teams evened out, stopping capture clock")
		team_to_capture = Team.TeamName.NEUTRAL
		capture_timer.stop()
	elif majority_team == team.team:
		print ("owning team regained mayority,stopping capture clock")
		team_to_capture = Team.TeamName.NEUTRAL
		capture_timer.stop()
	else:
		print ("New team has majority in base, starting capture clock")
		team_to_capture = majority_team
		capture_timer.start()


func get_team_with_majority() -> int:
	if enemy_unit_count == player_unit_count:
		return Team.TeamName.NEUTRAL
	elif enemy_unit_count > player_unit_count:
		return Team.TeamName.ENEMY
	else:
		return Team.TeamName.PLAYER


func set_team(new_team: int):
	team.team = new_team
	emit_signal("base_captured", new_team)
	match new_team:
		Team.TeamName.NEUTRAL:
			sprite.modulate = neutral_color
			return
		Team.TeamName.PLAYER:
			sprite.modulate = player_color
		Team.TeamName.ENEMY:
			sprite.modulate = enemy_color
			return


func _on_CaptureTimer_timeout():
	set_team(team_to_capture)

extends Node2D


const Player = preload("res://Player.tscn")
const GmaeOver = preload("res://Scenes/GameOverScreen.tscn")
const Pause = preload("res://Scenes/PauseScreen.tscn")



onready var ally_ai = $AllyMapAI
onready var enemy_ai = $EnemyMapAI
onready var bullet_manager = $BulletManager
onready var camera = $Camera2D
onready var light = $Light2D
onready var gui = $GUI
onready var ground = $Ground
onready var pathfinding = $Pathfinding
var fullscreen = false



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	GlobalSignals.connect("bullet_fired", bullet_manager, "handle_bullet_spawned")
	var button_node = $Button # Adjust $Button to match the actual path to your button node
	var door_node = $Door
	
	button_node.connect("Is_Active", door_node, "_on_Button_Is_Active")
	
	
	
	var ally_respawns = $AllyRespawnPoints
	var enemy_respawns = $EnemyRespawnPoints
	

	pathfinding.create_navigation_map(ground)

	
	ally_ai.initialize(ally_respawns.get_children(), pathfinding)
	enemy_ai.initialize(enemy_respawns.get_children(), pathfinding)
	spawn_player()
	

func spawn_player():
	var player = Player.instance()
	add_child(player)
	player.set_camera_transform(camera.get_path())
	player.set_light_transform(light.get_path())
	gui.set_player(player)
	player.connect("died", self, "GameOver")
	player.connect("bullet_time", self, "Bullettime")
	player.connect("time_over", self, "Fadeout")
	player.connect("win", self, "return_to_end")

func return_to_menu():
	SceneTransition.change_scene("res://Scenes/Menu.tscn")
	
	if Globals.fullscreen:
		OS.window_fullscreen = true

func GameOver():
	var game_over = GmaeOver.instance()
	add_child (game_over)

func Bullettime():
	$CanvasLayer/AnimationPlayer.play("Bullettime")
	yield($CanvasLayer/AnimationPlayer, "animation_finished")

func Fadeout():
	$CanvasLayer/AnimationPlayer.play("RESET")
	yield($CanvasLayer/AnimationPlayer, "animation_finished")

func return_to_end():
	SceneTransition.change_scene("res://Scenes/Ending.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if not has_node("PauseScreen"):
			var pause_menu = Pause.instance()
			add_child(pause_menu)
		else:
			# Pause menu already exists, so you might want to handle it differently here
			pass



extends KinematicBody2D


const speed = 30
var current_state = IDLE
var dir = Vector2.DOWN
var can_interact = false
const DIALOG = preload("res://DialogBox.tscn")

var start_pos

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()
	start_pos = position
	

func _physics_process(delta):
	
	if current_state == 0:
		$AnimatedSprite.play("idle")
	if current_state == 1:
		$AnimatedSprite.play("idle")
	#if current_state == 2:
		#$AnimatedSprite.play("walk")
		
	
	
	match current_state:
		IDLE:
			pass
		#NEW_DIR:
			dir = choose([Vector2.RIGHT,Vector2.UP,Vector2.LEFT,Vector2.DOWN])
		#MOVE:
			#move(delta)
		
	

#func move(delta):
	#position += dir * speed * delta
	#if dir.x == 1:
		#rotation_degrees = -90
	#elif dir.x == -1:
		#rotation_degrees = 90
	#lif dir.y == 1:
		#rotation_degrees = 0
	#elif dir.y == -1:
		#rotation_degrees = 180
	#rotation = deg2rad(rotation_degrees)
	
	
	#if position.x >= start_pos.x + 40:
		#position.x = start_pos.x + 39.9
	#if position.x <= start_pos.x - 40:
		#position.x = start_pos.x - 39.9
	#if position.y >= start_pos.y + 40:
		#position.y = start_pos.y + 39.9
	#if position.y <= start_pos.y - 40:
		#position.y = start_pos.y - 39.9

func choose(array):
	array.shuffle()
	return array.front()


func _on_Timer_timeout():
	$Timer.wait_time = choose([0.4, 0.6, 0.8])
	current_state = choose([IDLE, NEW_DIR, MOVE])


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		$Label.visible = true
		can_interact = true


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		$Label.visible = false
		can_interact = false
		
func _input(event):
	if Input.is_key_pressed(KEY_E) and can_interact == true:
		find_and_use_dialogue()
		$Label.visible = false

func find_and_use_dialogue():
	var dialogue_player = get_node_or_null("DialoguePlayer")
	
	if dialogue_player:
		dialogue_player.play()




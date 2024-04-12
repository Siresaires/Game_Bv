extends CanvasLayer

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS


func _on_Button_pressed():
	get_tree().paused = false
	queue_free()


func _on_Button2_pressed():
	Global.save_score()
	SceneTransition.change_scene("res://Scenes/Menu.tscn")
	

extends Control



func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Global.load_score()
	$Score.text = "Score : " + str(Global.score)
	$Best.text = "Best : " + str(Global.best_score)
	if not Globals.fullscreen:
		OS.window_fullscreen = true
		Globals.fullscreen = true

func _on_TragicPlay_pressed():
	$Button.play()
	Global.score = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	SceneTransition.change_scene("res://Main.tscn")


func _on_TragicQuit_pressed():
	$Button.play()
	get_tree().quit()

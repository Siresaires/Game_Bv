extends CanvasLayer



func _on_RestartButton_pressed():
	get_tree().paused = false
	Global.score = 0
	SceneTransition.change_scene("res://Main.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_MainMenuButton_pressed():
	get_tree().paused = false
	SceneTransition.change_scene("res://Scenes/Menu.tscn")

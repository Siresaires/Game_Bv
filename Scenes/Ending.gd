extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)




func _on_TextureButton_pressed():
	get_tree().quit()

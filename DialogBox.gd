extends CanvasLayer

export var dialog = [
	'In my restless dreams...i see that town',
	'Silent ground'
]

var dialog_index = 0
var finished = false 

func _ready():
	load_dialog()

func _physics_process(delta):
	$"Ind".visible = finished
	if Input.is_action_just_pressed("ui_accept"):
		load_dialog()

func load_dialog():
	if dialog_index < dialog.size():
		finished = false
		$RichTextLabel.bbcode_text = dialog[dialog_index]
		$RichTextLabel.percent_visible = 0
		$Tween.interpolate_property(
			$RichTextLabel, "percent_visible", 0, 1, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		$Tween.start()
	else:
		queue_free()
	dialog_index += 1

func _on_Tween_tween_completed(object, key):
	finished = true

extends Node2D

var scoring

func start(var scoring):
	self.scoring = scoring
	if scoring:
		$TextAnimation.play("Score")
		$Confetti.play("Confetti")

func _ready() -> void:
	$Label.text = str(Global.score)

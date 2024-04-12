extends Area2D

func _ready():
	connect("area_entered", self, "_on_AreaEntered")

func _on_AreaEntered(area):
	if area.is_in_group("BloodParticles"):
		area.queue_free()  # Remove the BloodParticles node when it collides with the Area2D

func _on_Area2D_area_entered(area):
	if area.is_in_group("BloodParticles"):
		area.queue_free()

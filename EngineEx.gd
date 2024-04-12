extends Node2D

export(float) var time_scale = 1.0 setget set_time_scale

func set_time_scale(value) -> void:
	time_scale = value
	Engine.time_scale = value
	AudioServer.global_rate_scale = 2.0 - value

extends Node2D

export (int) var score = 100 setget set_score

func set_score(new_score: int):
	score = clamp(new_score, 0, 100)

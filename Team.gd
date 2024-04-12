extends Node2D
class_name Team


enum TeamName {
	NEUTRAL,
	PLAYER,
	ENEMY,
	PROTAGONIST
}


export (TeamName) var team = TeamName.NEUTRAL

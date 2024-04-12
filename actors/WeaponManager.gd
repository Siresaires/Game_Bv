extends Node2D



signal toggle_shooting
signal weapon_changed(new_weapon)
signal not_bullet_time


onready var current_weapon: Weapon = $Uzi


var weapons: Array= []

var allow_input = true

func _ready():
	weapons = get_children()
	
	for weapon in weapons:
		weapon.is_player_weapon = true
		weapon.hide()
	
	current_weapon.show()
	



func _process(delta):
	if not current_weapon.semi_auto and Input.is_action_pressed("shoot"):
		current_weapon.shoot()




func initialize(team: int) -> void:
	for weapon in weapons:
		weapon.initialize(team)


func get_current_weapon() -> Weapon:
	return current_weapon





func switch_weapon(weapon: Weapon):
	if weapon == current_weapon:
		return
	
	current_weapon.hide()
	weapon.show()
	current_weapon = weapon
	emit_signal("weapon_changed", current_weapon)


func _unhandled_input(event: InputEvent) -> void:
	if allow_input:
		if current_weapon.semi_auto and event.is_action_pressed("shoot"):
			emit_signal("not_bullet_time")
			current_weapon.shoot()
			current_weapon.add_to_group("player_bullets")
			print("still kicking")
		elif event.is_action_released("weapon_1"):
			switch_weapon(weapons[0])
		pass



func allow_input(active):
	set_physics_process(active)
	set_process(active)
	set_process_input(active)


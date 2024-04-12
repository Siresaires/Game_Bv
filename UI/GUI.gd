extends CanvasLayer


onready var health_bar = $MarginContainer/Rows/BottomRow/HealthSection/health_bar
onready var health_tween = $MarginContainer/Rows/BottomRow/HealthSection/HealthTween
onready var current_ammo = $MarginContainer/Rows/BottomRow/AmmoSection/CurrentAmmo
onready var max_ammo = $MarginContainer/Rows/BottomRow/AmmoSection/MaxAmmo

onready var bullet_time = $MarginContainer/Rows/BottomRow/HBoxContainer/CenterContainer/bullet_time
onready var bullet_tween = $MarginContainer/Rows/BottomRow/HBoxContainer/CenterContainer/bullet_tween

var player: Player



func set_player(player: Player):
	self.player = player

	
	player.connect("bar_duration", self, "_on_BarDuration")
	
	
	
	set_new_health_value(player.health_stat.health) #here is were it connects
	player.connect("player_health_changed", self, "set_new_health_value")
	
	
	
	set_weapon(player.weapon_manager.get_current_weapon())
	player.weapon_manager.connect("weapon_changed", self, "set_weapon")


func set_weapon(weapon: Weapon):
	set_current_ammo(weapon.current_ammo)
	set_max_ammo(weapon.max_ammo)
	if not weapon.is_connected("weapon_ammo_changed", self, "set_current_ammo"):
		weapon.connect("weapon_ammo_changed", self, "set_current_ammo")


func set_current_ammo(new_ammo: int):
	current_ammo.text = str(new_ammo)


func set_max_ammo(new_max_ammo: int):
	max_ammo.text = str(new_max_ammo)


func set_new_health_value(new_health: int):
	var original_color = Color("#4f1d1d")
	var highlight_color = Color("#794545")
	
	var bar_style = health_bar.get("custom_styles/fg")
	health_tween.interpolate_property(health_bar, "value", health_bar.value, new_health, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN)
	health_tween.interpolate_property(bar_style, "bg_color", original_color, highlight_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	health_tween.interpolate_property(bar_style, "bg_color", highlight_color, original_color, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.2)
	health_tween.start()
	$Drop.play()
	
	




func _on_BarDuration(fulltime):
	# First, drop the bar to zero over the duration of the bullet time (0.6 seconds)
	bullet_tween.interpolate_property(bullet_time, "value", 100, 0, 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	# Then, schedule the refill to start immediately after the bullet time ends, filling over the remaining time
	bullet_tween.interpolate_property(bullet_time, "value", 0, 100, fulltime - 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.7)

	bullet_tween.start()



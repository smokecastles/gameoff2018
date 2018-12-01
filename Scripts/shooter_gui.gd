extends MarginContainer

onready var retry_container = $"VBoxContainer/Container/RetryContainer"
onready var victory_container = $"VBoxContainer/Container/victory_container"
onready var energy_container = $"VBoxContainer/HBoxContainer2"
onready var boss_health = $"VBoxContainer/boss_health/"


onready var bar_health = $"VBoxContainer/HBoxContainer/TextureProgress"
onready var bar_boss_health = $"VBoxContainer/boss_health/TextureProgress"
onready var tween_health = $TweenHealth
onready var tween_boss_health = $tween_boss_health

var animated_health = 0
var animated_energy = 0
var animated_boss_health = 0

var retry_shown = false

func _ready():
	var player_max_health = $"../../ship".armor
	bar_health.max_value = player_max_health
	update_health(player_max_health)
	boss_health.visible = false
	energy_container.visible = false

func _process(delta):
	bar_health.value = animated_health
	bar_boss_health.value = animated_boss_health
	if retry_shown:
		if Input.is_action_just_pressed("ui_accept"):
			Controller.reload_current_scene()

func show_boss_health(new_value):
	bar_boss_health.max_value = new_value
	boss_health.visible = true
	pass
	
func update_health(new_value):
	tween_health.interpolate_property(self, "animated_health", animated_health, new_value, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween_health.is_active():
    	tween_health.start()

func update_health_boss(new_value):
	tween_boss_health.interpolate_property(self, "animated_boss_health", animated_boss_health, new_value, 0.8, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween_boss_health.is_active():
		tween_boss_health.start()
	pass

func _on_Player_damage_taken(health):
	update_health(health)

func _on_Player_player_died():
	retry_container.visible = true
	retry_shown = true

func _on_player_won():
	victory_container.visible = true
	pass
	
func _on_boss_damage_taken(health):
	update_health(health)
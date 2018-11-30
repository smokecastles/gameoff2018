extends MarginContainer

onready var retry_container = $"VBoxContainer/Container/RetryContainer"

onready var bar_health = $"VBoxContainer/HBoxContainer/TextureProgress"
onready var tween_health = $TweenHealth

var animated_health = 0
var animated_energy = 0

var retry_shown = false

func _ready():
	var player_max_health = $"../../ship".armor
	bar_health.max_value = player_max_health
	update_health(player_max_health)

func _process(delta):
	bar_health.value = animated_health
	
	if retry_shown:
		if Input.is_action_just_pressed("ui_accept"):
			Controller.reload_current_scene()

func update_health(new_value):
	tween_health.interpolate_property(self, "animated_health", animated_health, new_value, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween_health.is_active():
    	tween_health.start()

func _on_Player_damage_taken(health):
	update_health(health)

func _on_Player_player_died():
	retry_container.visible = true
	retry_shown = true
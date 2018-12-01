extends MarginContainer

onready var retry_container = $"VBoxContainer/Container/RetryContainer"
onready var player_text_container = $"VBoxContainer/Container/PlayerTextContainer"

onready var bar_health = $"VBoxContainer/HBoxContainer/TextureProgress"
onready var bar_energy = $"VBoxContainer/HBoxContainer2/TextureProgress"
onready var tween_health = $TweenHealth
onready var tween_energy = $TweenEnergy
onready var player_text = $"VBoxContainer/Container/PlayerTextContainer/PlayerText"
onready var player_text_timer = $"VBoxContainer/Container/PlayerTextContainer/PlayerTextTimer"

var animated_health = 0
var animated_energy = 0

var retry_shown = false
var player_text_container_shown = false

func _ready():
	var player_max_health = $"../../Player".MAX_HEALTH
	bar_health.max_value = player_max_health
	update_health(player_max_health)
	var player_max_energy = $"../../Player".MAX_JETPACK_ENERGY
	bar_energy.max_value = player_max_energy
	update_energy(player_max_energy)
	$"VBoxContainer/boss_health/".visible = false

func _process(delta):
	bar_health.value = animated_health
	bar_energy.value = animated_energy
	
	if retry_shown:
		if Input.is_action_just_pressed("ui_accept"):
			Controller.reload_current_scene()

func update_health(new_value):
	tween_health.interpolate_property(self, "animated_health", animated_health, new_value, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween_health.is_active():
    	tween_health.start()

func update_energy(new_value):
	tween_energy.interpolate_property(self, "animated_energy", animated_energy, new_value, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween_energy.is_active():
    	tween_energy.start()

func _on_Player_damage_taken(health):
	update_health(health)

func _on_Player_energy_spent(new_value):
	update_energy(new_value)

func _on_Player_player_died():
	retry_container.visible = true
	retry_shown = true

func _on_Text_show_text_box(text):
	player_text.text = text
	player_text_container.visible = true
	player_text_timer.start()
	yield(player_text_timer, "timeout")
	player_text_container.visible = false
	pass

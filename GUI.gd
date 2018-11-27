extends MarginContainer

onready var bar_health = $"VBoxContainer/HBoxContainer/TextureProgress"
onready var bar_energy = $"VBoxContainer/HBoxContainer2/TextureProgress"
onready var tween_health = $TweenHealth
onready var tween_energy = $TweenEnergy

var animated_health = 0
var animated_energy = 0

func _ready():
	var player_max_health = $"../../Player".MAX_HEALTH
	bar_health.max_value = player_max_health
	update_health(player_max_health)
	var player_max_energy = $"../../Player".MAX_JETPACK_ENERGY
	bar_energy.max_value = player_max_energy
	update_energy(player_max_energy)

func _process(delta):
	bar_health.value = animated_health
	bar_energy.value = animated_energy 

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
	Controller.get_current_scene().get_tree().paused = true

extends MarginContainer

onready var bar = $"VBoxContainer/TextureProgress"
onready var tween = $Tween

var animated_health = 0

func _ready():
	var player_max_health = $"../../Player".MAX_HEALTH
	bar.max_value = player_max_health
	update_health(player_max_health)

func _process(delta):
    bar.value = animated_health

func update_health(new_value):
	tween.interpolate_property(self, "animated_health", animated_health, new_value, 0.6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	if not tween.is_active():
    	tween.start()

func _on_Player_damage_taken(health):
	update_health(health)

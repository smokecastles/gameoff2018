extends Area2D

export var armor = 2 setget set_armor
export var velocity = Vector2()
onready var size = get_node("sprite").texture.get_size()
onready var camera = get_node("/root/Node2D/camera")
onready var audio_player = get_node("/root/space_shooter/audio_player")

const scn_explosion = preload("res://scenes/explosion.tscn")

func _ready():
	set_process(true)
	add_to_group("enemy")
	connect("area_entered", self, "_on_area_enter")
	pass
	
func _process(delta):
	translate(velocity * delta)
	
	if position.y >= get_viewport_rect().size.y + size.y:
		queue_free()
	pass

func _on_area_enter(other):
	if other.is_in_group("ship"):
		other.armor -= 1
		if(camera != null):
			camera.shake(3, 0.13)
		queue_free()
	pass

func set_armor(new_value):
	if new_value < armor:
		audio_player.play_sfx("enemy_hit")
	if is_queued_for_deletion():
		return
	armor = new_value
	if armor <=0: 
		create_explosion()
		queue_free()
	pass
	
func create_explosion():
	var explosion = scn_explosion.instance()
	explosion.position = position
	get_tree().get_root().add_child(explosion)
	audio_player.play_sfx("enemy_explosion")
	pass
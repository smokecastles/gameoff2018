extends "res://scripts/enemy.gd"

const scn_laser = preload("res://scenes/laser_enemy.tscn")

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	randomize()
	var rand = randi()%2
	if(rand == 0):
		velocity.x = -velocity.x
		
	yield(get_tree().create_timer(.5), "timeout")
	shoot()
	pass

func _process(delta):
	if position.x <= 0 + size.x/2:
		velocity.x = abs(velocity.x)
	if position.x >= get_viewport().get_visible_rect().size.x - size.x/2:
		velocity.x = -abs(velocity.x)
	pass
	
func shoot():
	while true:
		audio_player.play_sfx("enemy_shoot")
		var laser = scn_laser.instance()
		laser.position = get_node("cannon").global_position
		get_tree().get_root().add_child(laser)
		
		yield(get_tree().create_timer(.5), "timeout")
	pass

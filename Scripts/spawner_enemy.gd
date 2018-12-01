extends Node

const scn_boss = preload("res://scenes/boss.tscn")
const enemies = [
preload("res://scenes/enemy_kamikaze.tscn")
,preload("res://scenes/enemy_clever.tscn"),
]


export var begin_spawn = false
export var spawn = false
export var time_for_boss = 1
var timer = 0

func _ready():
	spawn = false
	pass
	
func _process(delta):
	if(begin_spawn == true):
		begin_spawn = false
		spawn = true
		timer = time_for_boss
		spawn()
	if(spawn == true):
		timer = timer - delta
		if(timer < 0):
			spawn = false
			spawn_boss()
	pass

func spawn():
	while spawn:
		randomize()
		var rand = randi()%2
		var enemy = enemies[rand].instance()
		var pos = Vector2()
		randomize()
		pos.x = rand_range(0+16,get_viewport().get_visible_rect().size.x-16)
		pos.y = 0-16
		enemy.position = pos
		get_node("Container").add_child(enemy)
		yield(get_tree().create_timer(rand_range(0.5, 1.25)),"timeout")
	pass

func spawn_boss():
	var boss = scn_boss.instance()
	get_tree().get_root().add_child(boss)
	boss.do_animation_intro()
	var camera = get_node("/root/space_shooter/camera_shake")
	camera.shake(5, 5)
	var gui  = get_node("/root/space_shooter/CanvasLayer/GUI")
	gui.show_boss_health(boss.armor)
	gui.update_health_boss(boss.armor)
	boss.start_boss_battle()
	pass

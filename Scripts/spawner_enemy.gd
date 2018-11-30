extends Node

const enemies = [
preload("res://scenes/enemy_kamikaze.tscn")
,preload("res://scenes/enemy_clever.tscn")]

func _ready():
	spawn()
	pass

func spawn():
	while true:
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

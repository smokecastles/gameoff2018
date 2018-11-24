extends Node

const INVADERS = preload("res://Invaders.tscn")

onready var invaders_pathfollow2d = $"InvadersPath2D/InvadersPathFollow2D"

func _ready():
	var invaders = INVADERS.instance()
	invaders.addAsGrid(Vector2(4, 2))
	invaders_pathfollow2d.add_child(invaders)
	invaders.create_invaders(10)
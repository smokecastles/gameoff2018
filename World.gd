extends Node

const Invader = preload("res://Invader.tscn")

onready var invaders_pathfollow2d = $"InvadersPath2D/InvadersPathFollow2D"
onready var invaders_formation = $"InvadersPath2D/InvadersPathFollow2D/InvadersFormation"
onready var invaders_inline = $"InvadersInLine"
onready var invaders = $Invaders

func _ready():
	var invader = Invader.instance()
	invader.global_position = Vector2(100,300)
	invaders.add_child(invader)
	invaders_formation.add_invader(invader)
	
	for i in range(0,1):
		invader = Invader.instance()
		invader.global_position = Vector2(0,300)
		invaders.add_child(invader)
		invaders_formation.add_invader(invader)

func _physics_process(delta):
	for node in invaders.get_children():
		move_invader(node, delta)
	pass

func move_invader(invader, delta):
	match invader.state:
		invader.STATES.SWITCHING_TO_FORMATION:
			invader.move_to_position(invaders_formation.get_invader_global_pos(invader), delta)
		invader.STATES.SWITCHING_TO_IN_LINE:
			invader.move_to_position(invaders_inline.get_invader_global_pos(invader), delta)

func set_invader_transitioning_to_formation(invader):
	var cur_position = invader.global_position
	invaders_formation.add_invader(invader)
	invaders_inline.remove_invader(invader)
	invaders_inline.remove_child(invader)
	invaders.add_child(invader)
	invader.global_position = cur_position

func set_invader_transitioning_to_in_line(invader):
	var cur_position = invader.global_position
	invaders_inline.add_invader(invader)
	invaders_formation.remove_invader(invader)
	invaders_formation.remove_child(invader)
	invaders.add_child(invader)
	invader.global_position = cur_position
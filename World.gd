extends Node

const Invader = preload("res://Invader.tscn")

onready var invaders_pathfollow2d = $"InvadersPath2D/InvadersPathFollow2D"
onready var invaders_formation = $"InvadersPath2D/InvadersPathFollow2D/InvadersFormation"
onready var invaders = $Invaders

func _ready():
	var invader = Invader.instance()
	invader.global_position = Vector2(100,300)
	invaders.add_child(invader)
	invaders_formation.add_invader(invader)
	
	for i in range(0,5):
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
			var traversed_distance = invader.SPEED * delta
			var current_pos = invader.global_position
			var final_pos = invaders_formation.get_invader_global_pos(invader)
			
			var distance_between_pos = current_pos.distance_to(final_pos)
			
			if distance_between_pos < 5:
				invader.state = invader.STATES.IN_FORMATION
				invaders.remove_child(invader)
				invaders_formation.add_child(invader)
				invader.global_position = final_pos
			else:
				invader.position = invader.position.linear_interpolate(final_pos, traversed_distance / distance_between_pos)

func set_invader_transitioning(invader):
	var cur_position = Vector2(0,0) # TODO
	invaders.add_child(invader)
extends Node

const Invader = preload("res://Invader.tscn")

onready var invaders_path2d = $"InvadersPath2D"
onready var invaders_pathfollow2d = $"InvadersPath2D/InvadersPathFollow2D"
onready var invaders_formation = $"InvadersPath2D/InvadersPathFollow2D/InvadersFormation"
onready var invaders_inline = $"InvadersInLine"
onready var invaders = $Invaders
onready var player = $Player

func _ready():
	var invader = Invader.instance()
	invader.global_position = Vector2(100,300)
	invaders.add_child(invader)
	invaders_formation.add_invader(invader)
	
	for i in range(0,10):
		invader = Invader.instance()
		invader.global_position = Vector2(0,300)
		invaders.add_child(invader)
		invaders_formation.add_invader(invader)

func _physics_process(delta):
	for node in invaders.get_children():
		move_invader(node, delta)
	pass
	move_invader_groups_to_follow_player(delta)

func move_invader(invader, delta):
	match invader.state:
		invader.STATES.SWITCHING_TO_FORMATION:
			invader.move_to_position(invaders_formation.get_invader_global_pos(invader), delta)
		invader.STATES.SWITCHING_TO_IN_LINE:
			invader.move_to_position(invaders_inline.get_invader_global_pos(invader), delta)

func move_invader_groups_to_follow_player(delta):
	for node in [invaders_inline, invaders_path2d]:
		var traversed_distance = 400 * delta
		var current_pos = node.global_position
		var final_pos = Vector2(player.global_position.x, current_pos.y) 
	
		var distance_between_pos = current_pos.distance_to(final_pos)
	
		if distance_between_pos < 5:
			node.global_position = final_pos
		else:
			node.global_position = node.global_position.linear_interpolate(final_pos, traversed_distance / distance_between_pos)

func set_invader_transitioning_to_formation(invader):
	var cur_position = invader.global_position
	invaders_formation.add_invader(invader)
	invaders_inline.remove_invader(invader)
	if invader.get_parent() == invaders_inline:
		invaders_inline.remove_child(invader)
	if not invader.get_parent():
		invaders.add_child(invader)
	invader.global_position = cur_position

func set_invader_transitioning_to_in_line(invader):
	var cur_position = invader.global_position
	invaders_inline.add_invader(invader)
	invaders_formation.remove_invader(invader)
	if invader.get_parent() == invaders_formation:
		invaders_formation.remove_child(invader)
	if not invader.get_parent():
		invaders.add_child(invader)
	invader.global_position = cur_position

func _on_HeightDetectionArea2D_body_entered(body):
	if body.get_name() == "Player":
		if body.motion.y < 0:
			invaders_formation.switch_all_to_in_line()

func _on_HeightDetectionArea2D_body_exited(body):
	if body.get_name() == "Player":
		if body.motion.y > 0:
			invaders_inline.switch_all_to_formation()

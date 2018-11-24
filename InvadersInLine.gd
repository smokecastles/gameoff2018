extends Node2D

var invaders = []

var H_OFFSET = 200

onready var path2d = $Path2D
onready var pathfollow2d = $"Path2D/PathFollow2D"

func add_invader(invader):
	for i in range(len(invaders)):
		if invaders[i] == null:
			invader.pos_in_line = i
			invaders[i] = invader
			return
	
	invader.pos_in_line = len(invaders)
	invaders.append(invader)

func remove_invader(invader):
	var x = invader.pos_in_line
	if len(invaders) > x:
		invaders[x] = null

func get_invader_global_pos(invader):
	var unit_offset = float(invader.pos_in_line) / (len(invaders))
	pathfollow2d.unit_offset = unit_offset
	var even = invader.pos_in_line % 2 == 0
	var local_pos = pathfollow2d.position + Vector2(H_OFFSET if even else -H_OFFSET, 0)
	return to_global(local_pos)

func _physics_process(delta):
	for invader in invaders:
		if not invader:
			continue
		match invader.state:
			invader.STATES.IN_LINE:
				invader.move_to_position(get_invader_global_pos(invader), delta)
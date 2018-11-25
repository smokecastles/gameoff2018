extends Node2D

var invaders = []

const H_OFFSET = 400
const TIME_OFFSET_BETWEEN_SHOTS_MS = 1000
var time = 0

enum SHOOT_TURNS { LEFT, RIGHT }
var shoot_turn = SHOOT_TURNS.LEFT

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

func switch_all_to_formation():
	for x in range(len(invaders)):
		if invaders[x]:
			invaders[x].to_formation()

func _physics_process(delta):
	var elapsed_time = OS.get_ticks_msec() - time
	var will_shoot = false
	if elapsed_time >= TIME_OFFSET_BETWEEN_SHOTS_MS:
		time = OS.get_ticks_msec()
		will_shoot = true
		shoot_turn = SHOOT_TURNS.LEFT if shoot_turn == SHOOT_TURNS.RIGHT else SHOOT_TURNS.RIGHT
	
	for invader in invaders:
		if not invader:
			continue
		if will_shoot:
			var must_shoot = invader.pos_in_line % 2 == 0 and shoot_turn == SHOOT_TURNS.RIGHT
			must_shoot = must_shoot or invader.pos_in_line % 2 != 0 and shoot_turn == SHOOT_TURNS.LEFT
			print(must_shoot)
			if must_shoot:
				invader.shoot_sidewards(-1 if shoot_turn == SHOOT_TURNS.RIGHT else 1)
		match invader.state:
			invader.STATES.IN_LINE:
				invader.move_to_position(get_invader_global_pos(invader), delta)
extends Node2D

const INVADER = preload("res://Invader.tscn")
const MAX_COLS = 8

var invaders = [[]]

func add_invader(invader):
	# First try to fit it in current empty spots
	for x in range(len(invaders)):
		for y in range(len(invaders[x])):
			if not invaders[x][y]:
				invader.set_pos_in_formation(Vector2(x,y))
				invaders[x][y] = invader
				return
	
	if len(invaders) < MAX_COLS:
		invader.set_pos_in_formation(Vector2(len(invaders), 0))
		invaders.append([invader])
	else:
		var y_len = len(invaders[0])
		for x in range(len(invaders)):
			if len(invaders[x]) < y_len:
				invader.set_pos_in_formation(Vector2(x, len(invaders[x])))
				invaders[x].append(invaders)
				return
		invader.set_pos_in_formation(Vector2(0, y_len))
		invaders[0].append(invader)

func remove_invader(invader):
	var x = invader.pos_in_formation.x
	var y = invader.pos_in_formation.y
	if len(invaders) > x and len(invaders[x]) > y:
		invaders[x][y] = null

func get_invader_global_pos(invader):
	var frame_size = invader.get_node("AnimatedSprite").frames.get_frame("default",0).get_size()
	var local_pos = Vector2(0,-frame_size.y * (len(invaders[0]))) + invader.pos_in_formation * frame_size * invader.scale
	return to_global(local_pos)

func switch_all_to_in_line():
	for x in range(len(invaders)):
		for y in range(len(invaders[x])):
			if invaders[x][y]:
				invaders[x][y].to_in_line()

func _debug_print_invaders():
	var rows = []
	for x in range(len(invaders)):
		for y in range(len(invaders[x])):
			if len(rows) <= y:
				rows.append("")
			if invaders[x][y]:
				rows[y] +=  " I "
			else:
				rows[y] +=  " x "
	print("====")
	for row in rows:
		print(row)
	print("====")

func create_invaders(num):
	for i in range(num):
		var invader = INVADER.instance()
		add_invader(invader)
	_debug_print_invaders()

func addAsGrid(size):
	for y in range (size.y):
		var newPos = Vector2(0, y)
		for x in range (size.x):
			newPos.x = x
			createInvader(newPos)

func createInvader(pos):
	var invader = INVADER.instance()
	invader.position = pos * invader.get_node("AnimatedSprite").frames.get_frame("default",0).get_size() * invader.scale
	add_child(invader)

func _process(delta):
	pass
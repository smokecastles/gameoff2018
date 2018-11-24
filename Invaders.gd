extends Node2D

const INVADER = preload("res://Invader.tscn")
const MAX_COLS = 4

var invaders = [[]]

func add_invader(invader):
	for x in range(len(invaders)):
		for y in range(len(invaders[x])):
			if not invaders[x][y]:
				invaders[x][y] = invader
				return
	
	if len(invaders) <= MAX_COLS:
		invaders.append([invader])
	else:
		var y_len = len(invaders[0])
		for x in invaders:
			if len(x) < y_len:
				x.append(invaders)
				return
		invaders[0].append([invader])

func remove_invader(x, y):
	if len(invaders) > x and len(invaders[x]) > y:
		invaders[x][y] = null

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
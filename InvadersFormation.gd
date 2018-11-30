extends Node2D

const MAX_COLS = 5
const TIME_OFFSET_BETWEEN_SHOTS_S = 0.5 # half a sec

var invaders = []
var elapsed_time = 0

func add_invader(invader):
	#print("[+] Adding invader FORMATION")
	# First try to fit it in current empty spots
	if len(invaders) > 0:
		var y_len = len(invaders[0])
		for y in range(0, y_len):
			for x in range(len(invaders)):
				if len(invaders[x]) > y:
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
				invaders[x].append(invader)
				return
		invader.set_pos_in_formation(Vector2(0, y_len))
		invaders[0].append(invader)

func remove_invader(invader):
	var x = invader.pos_in_formation.x
	var y = invader.pos_in_formation.y
	#print("[-] Removing invader FORMATION @ (%s, %s)..." % [x,y])
	if len(invaders) > x and len(invaders[x]) > y:
		#print("[-] Removed invader FORMATION @ (%s, %s)\n" % [x,y])
		invaders[x][y] = null

func get_invader_global_pos(invader):
	var frame_size = invader.get_node("AnimatedSprite").frames.get_frame("default",0).get_size()
	var y_len = len(invaders[0])
	while not invaders[0][y_len-1] and y_len > 0:
		y_len -= 1
	var local_pos = Vector2(0,-frame_size.y * invader.scale.y * (max(1,y_len-1))) + invader.pos_in_formation * frame_size * invader.scale
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

func _debug_print_invaders_statis_from_scene():
	var invaders = Controller.get_current_scene().get_node("Invaders").get_children()
	for invader in invaders:
		print(invader.get_name() + " %s" % invader.state)

func _physics_process(delta):
	if len(invaders) == 0:
		return
	elapsed_time += delta
	var will_shoot = false
	if elapsed_time >= TIME_OFFSET_BETWEEN_SHOTS_S:
		#_debug_print_invaders_statis_from_scene()
		elapsed_time = 0
		# Randomly choose which invader in the lowest row will shoot
		var shooter_col = randi() % len(invaders)
		var col_length = len(invaders[shooter_col])
		if col_length == 0:
			return
		var last_index = col_length - 1
		while not invaders[shooter_col][last_index] and last_index > 0:
			print("No invader at %s" % last_index)
			_debug_print_invaders()
			last_index -= 1
		var invader = invaders[shooter_col][last_index]
		print("Shooting invader: (%s, %s)" % [shooter_col, last_index])
		var player_alive = !Controller.get_current_scene().player.is_dead
		if invader and invader.state == invader.STATES.IN_FORMATION and player_alive:
			invader.shoot_downwards()
			
	for col in invaders:
		for invader in col:
			if not invader:
				continue
			match invader.state:
				invader.STATES.IN_FORMATION:
					invader.move_to_position(get_invader_global_pos(invader), delta)
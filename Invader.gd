extends KinematicBody2D

var SPEED = 700

var path = Navigation2D.new()
var pos_in_formation = Vector2(0, 0)
var pos_in_line = 0

enum STATES { IN_FORMATION, IN_LINE, SWITCHING_TO_FORMATION, SWITCHING_TO_IN_LINE }

var state = STATES.SWITCHING_TO_FORMATION

func _ready():
	pass
	
func _physics_process(delta):
	pass
	#if Input.is_action_just_pressed("ui_accept"):
	#	match state:
	#		IN_FORMATION, SWITCHING_TO_FORMATION: to_in_line()
	#		IN_LINE, SWITCHING_TO_IN_LINE: to_formation()

func set_pos_in_formation(pos):
	self.pos_in_formation = pos
	
func move_to_position(pos, delta):
	var traversed_distance = SPEED * delta
	var current_pos = global_position
	var final_pos = pos
	
	var distance_between_pos = current_pos.distance_to(final_pos)
	
	if distance_between_pos < 20:
		global_position = final_pos
	else:
		global_position = global_position.linear_interpolate(final_pos, traversed_distance / distance_between_pos)

func to_formation():
	match state:
		IN_LINE, SWITCHING_TO_IN_LINE:
			state = SWITCHING_TO_FORMATION
			Controller.get_current_scene().set_invader_transitioning_to_formation(self)

func to_in_line():
	match state:
		IN_FORMATION, SWITCHING_TO_FORMATION:
			state = SWITCHING_TO_IN_LINE
			Controller.get_current_scene().set_invader_transitioning_to_in_line(self)
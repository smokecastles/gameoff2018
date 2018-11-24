extends KinematicBody2D

var SPEED = 600

var path = Navigation2D.new()
var pos_in_formation = Vector2(0, 0)

enum STATES { IN_FORMATION, IN_LINE, SWITCHING_TO_FORMATION, SWITCHING_TO_IN_LINE }

var state = STATES.SWITCHING_TO_FORMATION

func _ready():
	pass

func set_pos_in_formation(pos):
	self.pos_in_formation = pos
	
func move_to_position(pos):
	pass

func to_formation():
	match state:
		IN_LINE, SWITCHING_TO_IN_LINE:
			state = SWITCHING_TO_FORMATION
			Controller.get_current_scene().set_invader_transitioning(self)

func to_in_line():
	match state:
		IN_FORMATION, SWITCHING_TO_FORMATION:
			state = SWITCHING_TO_IN_LINE
			Controller.get_current_scene().set_invader_transitioning(self)
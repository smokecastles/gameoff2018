extends KinematicBody2D

var SPEED = 700

const projectile = preload("res://Projectile.tscn")

onready var projectile_pos_down = $ProjectilePositionDown
onready var projectile_pos_side = $ProjectilePositionSide
onready var did_shoot_timer = $DidShootTimer

var path = Navigation2D.new()
var pos_in_formation = Vector2(0, 0)
var pos_in_line = 0
var did_shoot = false

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

func shoot_sidewards(x):
	if did_shoot:
		return
	if x > 0 and projectile_pos_side.position.x < 0 or x < 0 and projectile_pos_side.position.x > 0:
		projectile_pos_side.position.x *= -1
	var node = projectile.instance()
	node.set_direction_x(x)
	Controller.get_current_scene().add_child(node)
	node.position = projectile_pos_side.global_position
	did_shoot = true
	did_shoot_timer.start()

func shoot_downwards():
	if did_shoot:
		return
	var node = projectile.instance()
	node.set_direction_y(1)
	Controller.get_current_scene().add_child(node)
	node.position = projectile_pos_down.global_position
	did_shoot = true
	did_shoot_timer.start()

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

func _on_DidShootTimer_timeout():
	did_shoot = false

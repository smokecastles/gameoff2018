extends KinematicBody2D

var SPEED = 700

onready var projectile = Controller.projectile

onready var projectile_pos_down = $ProjectilePositionDown
onready var projectile_pos_side = $ProjectilePositionSide
onready var did_shoot_timer = $DidShootTimer
onready var dying_timer = $DyingTimer
onready var collision_shape = $CollisionPolygon2D

const UP = Vector2(0, -1)
const GRAVITY = 30

enum STATES { IN_FORMATION, IN_LINE, SWITCHING_TO_FORMATION, SWITCHING_TO_IN_LINE, DYING, DEAD }

var path = Navigation2D.new()
var pos_in_formation = Vector2(0, 0)
var pos_in_line = 0
var did_shoot = false

var state = STATES.SWITCHING_TO_FORMATION
var motion = Vector2()

func _ready():
	pass
	
func _physics_process(delta):
	#print(get_name() + " %s" % state)
	match state:
		DYING:
			motion.y += GRAVITY
			motion.x = 0
	
			motion = move_and_slide(motion, UP)
		DEAD:
			queue_free()

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
		if state == STATES.SWITCHING_TO_IN_LINE:
			state = STATES.IN_LINE
		elif state == STATES.SWITCHING_TO_FORMATION:
			state = STATES.IN_FORMATION
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

func damage():
	state = STATES.DYING
	motion.y = -500
	collision_shape.disabled = true
	z_index = -1
	var main_scene = Controller.get_current_scene()
	main_scene.invaders_formation.remove_invader(self)
	main_scene.invaders_inline.remove_invader(self)
	dying_timer.start()

func _on_DidShootTimer_timeout():
	did_shoot = false

func _on_DyingTimer_timeout():
	state = STATES.DEAD

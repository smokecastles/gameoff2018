extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 40
const ACCELERATION = 20
const MAX_SPEED = 250

const ANIM_WALK = "Walk"
const ANIM_DEAD = "Dead"

onready var sprite = $AnimatedSprite
onready var raycast = $RayCast2D
onready var dying_timer = $DyingTimer
onready var collision_shape = $CollisionShape2D

enum STATES { ALIVE, DYING, DEAD } 

var motion = Vector2()
var direction = -1
var state = ALIVE

func _ready():
	sprite.play(ANIM_WALK)
	pass

func _physics_process(delta):
	match state:
		ALIVE:
			process_state_alive(delta)
		DYING:
			process_state_dying(delta)
		DEAD:
			process_state_dead(delta)

func process_state_alive(delta):
	motion.y += GRAVITY
	
	if direction == 1:
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
		sprite.flip_h = true
	else:
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
		sprite.flip_h = false
	
	motion = move_and_slide(motion, UP)
	
	if is_on_wall() or (is_on_floor() and !raycast.is_colliding()):
		direction *= -1
		raycast.position.x *= -1

func process_state_dying(delta):
	sprite.play(ANIM_DEAD)
	
	motion.y += GRAVITY
	motion.x = min(motion.x, MAX_SPEED * direction)
	
	motion = move_and_slide(motion, UP)
	
func process_state_dead(delta):
	queue_free()

func damage():
	state = STATES.DYING
	motion.y = -500
	collision_shape.disabled = true
	dying_timer.start()

func _on_DyingTimer_timeout():
	state = STATES.DEAD

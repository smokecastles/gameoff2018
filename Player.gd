extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 40
const ACCELERATION = 50
const MAX_SPEED = 500
const JUMP_HEIGHT = -850
const JETPACK_DOWN_SPEED = -100
const JETPACK_HEIGHTDIFF_THRESHOLD = 30

const DAMPING_FLOOR = 0.2
const DAMPING_SKY = 0.05

const ANIM_IDLE = "Idle"
const ANIM_WALK = "Walk"
const ANIM_JUMP = "Jump"

const projectile = preload("res://Projectile.tscn")

onready var sprite = $AnimatedSprite
onready var projectile_pos = $ProjectilePosition

var motion = Vector2()
var falling_down = false
var latest_height = 0.0

func _physics_process(delta):
	motion.y += GRAVITY
	
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
		sprite.flip_h = false
		sprite.play(ANIM_WALK)
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
		sprite.flip_h = true
		sprite.play(ANIM_WALK)
	else:
		sprite.play(ANIM_IDLE)
		motion.x = lerp(motion.x, 0, DAMPING_FLOOR if is_on_floor() else DAMPING_SKY)
	
	if sprite.flip_h and projectile_pos.position.x > 0 or not sprite.flip_h and projectile_pos.position.x < 0:
		projectile_pos.position.x *= -1
	
	if Input.is_action_just_pressed("ui_accept"):
		var node = projectile.instance()
		node.set_direction(-1 if sprite.flip_h else 1)
		get_parent().add_child(node)
		node.position = projectile_pos.global_position
	
	var prev_falling_down = falling_down
	falling_down = motion.y > 0
	
	if not prev_falling_down and falling_down:
		latest_height = self.position.y
		
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
	elif falling_down:
		if Input.is_action_just_pressed("ui_up") and self.position.y - latest_height > JETPACK_HEIGHTDIFF_THRESHOLD:
			motion.y = -300
		elif Input.is_action_pressed("ui_up"):
			motion.y = -JETPACK_DOWN_SPEED

		sprite.play(ANIM_JUMP)
	
	motion = move_and_slide(motion, UP)
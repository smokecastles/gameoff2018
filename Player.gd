extends KinematicBody2D

signal damage_taken

const UP = Vector2(0, -1)
const GRAVITY = 40
const ACCELERATION = 50
const MAX_SPEED = 500
const JUMP_HEIGHT = -850
const SUPER_JUMP_HEIGHT = -2500
const DASH_DISTANCE = 1200
const JETPACK_DOWN_SPEED = -220
const JETPACK_HEIGHTDIFF_THRESHOLD = 10

const DAMPING_FLOOR = 0.2
const DAMPING_SKY = 0.05
const DAMPING_FALLING = 0.1

const MAX_HEALTH = 4

const ANIM_IDLE = "Idle"
const ANIM_WALK = "Walk"
const ANIM_JUMP = "Jump"

onready var projectile = Controller.projectile

onready var sprite = $AnimatedSprite
onready var projectile_pos = $ProjectilePosition
onready var invulnerable_after_hit_timer = $"InvulnerableAfterHitTimer"

var motion = Vector2()
var falling_down = false
var jetpack_on = false
var latest_height = 0.0

var health = MAX_HEALTH
var invulnerable = false

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
	
	if Input.is_action_just_released("left_dash"):
		motion.x = -DASH_DISTANCE
	elif Input.is_action_just_released("right_dash"):
		motion.x = DASH_DISTANCE
	
	if sprite.flip_h and projectile_pos.position.x > 0 or not sprite.flip_h and projectile_pos.position.x < 0:
		projectile_pos.position.x *= -1
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	var prev_falling_down = falling_down
	falling_down = motion.y > 0
	
	if not prev_falling_down and falling_down:
		latest_height = self.position.y
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			motion.y = JUMP_HEIGHT
		elif Input.is_action_pressed("left_dash") and Input.is_action_pressed("right_dash"):
			motion.y = SUPER_JUMP_HEIGHT
	else:
		sprite.play(ANIM_JUMP)
		if falling_down and Input.is_action_pressed("ui_accept"):
			motion.y = lerp(motion.y, JETPACK_DOWN_SPEED, DAMPING_FALLING)
			jetpack_on = true
		else:
			jetpack_on = false
	
	motion = move_and_slide(motion, UP)

func shoot():
	var node = projectile.instance()
	node.from_player = true
	node.set_direction_x(-1 if sprite.flip_h else 1)
	get_parent().add_child(node)
	node.position = projectile_pos.global_position

func damage():
	if not invulnerable:
		health -= 1
		emit_signal("damage_taken", health)
		invulnerable = true
		modulate = Color(1.0, 1.0, 1.0, 0.5)
		invulnerable_after_hit_timer.start()


func _on_InvulnerableAfterHitTimer_timeout():
	invulnerable = false
	modulate = Color(1.0, 1.0, 1.0, 1)

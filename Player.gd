extends KinematicBody2D

signal damage_taken
signal energy_spent
signal player_died

const UP = Vector2(0, -1)
const GRAVITY = 40
const ACCELERATION = 50
const MAX_SPEED = 500
const JUMP_HEIGHT = -850
const SUPER_JUMP_HEIGHT = -2500
const DASH_DISTANCE = 1200
const JETPACK_DOWN_SPEED = -220

const DAMPING_FLOOR = 0.2
const DAMPING_SKY = 0.05
const DAMPING_FALLING = 0.1

const MAX_HEALTH = 4
const MAX_JETPACK_ENERGY = 3
const JETPACK_ENERGY_FOR_SUPERJUMP = 2
const JETPACK_ENERGY_FOR_DASH = 0.5
const JETPACK_REGEN_SPEED = 0.3 # points per sec

const ANIM_IDLE = "Idle"
const ANIM_WALK = "Walk"
const ANIM_JUMP = "Jump"

onready var projectile = Controller.projectile

onready var sprite = $AnimatedSprite
onready var projectile_pos = $ProjectilePosition
onready var invulnerable_after_hit_timer = $InvulnerableAfterHitTimer

var motion = Vector2()
var falling_down = false
var jetpack_on = false
var just_superjumped_l_pressed = false
var just_superjumped_r_pressed = false
var latest_height = 0.0

var health = MAX_HEALTH
var invulnerable = false
var jetpack_energy = MAX_JETPACK_ENERGY

var elapsed_time = 0

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
		if not just_superjumped_l_pressed and jetpack_energy >= JETPACK_ENERGY_FOR_DASH:
			motion.x = -DASH_DISTANCE
			spend_energy(JETPACK_ENERGY_FOR_DASH)
		just_superjumped_l_pressed = false
	elif Input.is_action_just_released("right_dash"):
		if not just_superjumped_r_pressed and jetpack_energy >= JETPACK_ENERGY_FOR_DASH:
			motion.x = DASH_DISTANCE
			spend_energy(JETPACK_ENERGY_FOR_DASH)
		just_superjumped_r_pressed = false
	
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
			if jetpack_energy >= JETPACK_ENERGY_FOR_SUPERJUMP:
				spend_energy(JETPACK_ENERGY_FOR_SUPERJUMP)
				motion.y = SUPER_JUMP_HEIGHT
			just_superjumped_l_pressed = true
			just_superjumped_r_pressed = true
	else:
		sprite.play(ANIM_JUMP)
		if falling_down and Input.is_action_pressed("ui_accept"):
			motion.y = lerp(motion.y, JETPACK_DOWN_SPEED, DAMPING_FALLING)
			jetpack_on = true
		else:
			jetpack_on = false
	
	motion = move_and_slide(motion, UP)

func _process(delta):
	pass
	if not jetpack_on:
		jetpack_energy = max(0, min(MAX_JETPACK_ENERGY, jetpack_energy + JETPACK_REGEN_SPEED * delta))
		
		elapsed_time += delta
		if elapsed_time >= 0.5:
			elapsed_time = 0
			emit_signal("energy_spent", jetpack_energy)

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
		if health > 0:
			invulnerable = true
			modulate = Color(1.0, 1.0, 1.0, 0.5)
			invulnerable_after_hit_timer.start()
		else:
			var explosion = Controller.explosion_scene.instance()
			explosion.position = position
			Controller.get_current_scene().add_child(explosion)
			visible = false
			emit_signal("player_died")

func spend_energy(value):
	jetpack_energy -= value
	emit_signal("energy_spent", jetpack_energy)

func _on_InvulnerableAfterHitTimer_timeout():
	invulnerable = false
	modulate = Color(1.0, 1.0, 1.0, 1)

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
const DASH_DISTANCE = 1000
const JETPACK_DOWN_SPEED = -220

const DAMPING_FLOOR = 0.2
const DAMPING_SKY = 0.05
const DAMPING_FALLING = 0.1

const MAX_HEALTH = 4
const MAX_JETPACK_ENERGY = 3
const JETPACK_ENERGY_FOR_SUPERJUMP = 2
const JETPACK_ENERGY_FOR_DASH = 0.5
const JETPACK_REGEN_SPEED = 0.4 # points per sec

const DASHING_TIME = 0.2 # sec
const ANIM_TIME_HIT = 0.3 # sec

const ANIM_IDLE = "Idle"
const ANIM_WALK = "Walk"
const ANIM_JUMP = "Jump"
const ANIM_DASH_FRONT = "DashFront"
const ANIM_DASH_BACK = "DashBack"
const ANIM_HIT = "Hit"

onready var projectile = Controller.projectile_player

onready var sprite = $AnimatedSprite
onready var collision_polygon = $CollisionPolygon2D
onready var projectile_pos = $ProjectilePosition
onready var jetpack_particles = $JetpackParticles
onready var shot_particles = $ShotParticles
onready var dash_effect_right_particles = $DashEffectRightParticles
onready var dash_effect_left_particles = $DashEffectLeftParticles
onready var invulnerable_after_hit_timer = $InvulnerableAfterHitTimer
onready var shot_particles_timer = $"ShotParticles/ShotParticlesTimer"

var motion = Vector2()
var falling_down = false
var jetpack_on = false
var just_superjumped_l_pressed = false
var just_superjumped_r_pressed = false
var latest_height = 0.0

var health = MAX_HEALTH
var jetpack_energy = MAX_JETPACK_ENERGY

var superjumping = false
var invulnerable = false
var is_dead = false

var dashing_left = false
var dashing_right = false
var dashing_elapsed_time = 0

var just_hit = false
var anim_time_hit_elapsed_time = 0

var elapsed_time = 0

func _physics_process(delta):
	if is_dead:
		return
	
	motion.y += GRAVITY
	
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
		sprite.flip_h = false
		sprite.play(ANIM_WALK)
		collision_polygon.scale.x = 1
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
		sprite.flip_h = true
		collision_polygon.scale.x = -1
		sprite.play(ANIM_WALK)
	else:
		sprite.play(ANIM_IDLE)
		motion.x = lerp(motion.x, 0, DAMPING_FLOOR if is_on_floor() else DAMPING_SKY)
	
	if Input.is_action_just_released("left_dash"):
		if not just_superjumped_l_pressed and jetpack_energy >= JETPACK_ENERGY_FOR_DASH:
			dashing_left = true
			if sprite.flip_h:
				dash_effect_left_particles.emitting = true
			else:
				dash_effect_right_particles.emitting = true
			spend_energy(JETPACK_ENERGY_FOR_DASH)
		just_superjumped_l_pressed = false
	elif Input.is_action_just_released("right_dash"):
		if not just_superjumped_r_pressed and jetpack_energy >= JETPACK_ENERGY_FOR_DASH:
			dashing_right = true
			if sprite.flip_h:
				dash_effect_left_particles.emitting = true
			else:
				dash_effect_right_particles.emitting = true
			spend_energy(JETPACK_ENERGY_FOR_DASH)
		just_superjumped_r_pressed = false
	
	if dashing_left:
		motion.x = -DASH_DISTANCE
		motion.y = 0
		sprite.play(ANIM_DASH_BACK if not sprite.flip_h else ANIM_DASH_FRONT)
	elif dashing_right:
		motion.x = DASH_DISTANCE
		motion.y = 0
		sprite.play(ANIM_DASH_FRONT if not sprite.flip_h else ANIM_DASH_BACK)
	
	if dashing_left or dashing_right:
		dashing_elapsed_time += delta
		if dashing_elapsed_time > DASHING_TIME:
			dashing_elapsed_time = 0
			dashing_left = false
			dashing_right = false
			dash_effect_left_particles.emitting = false
			dash_effect_right_particles.emitting = false
	
	if sprite.flip_h and projectile_pos.position.x > 0 or not sprite.flip_h and projectile_pos.position.x < 0:
		projectile_pos.position.x *= -1
		jetpack_particles.position.x *= -1
		shot_particles.position.x *= -1
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	var prev_falling_down = falling_down
	falling_down = motion.y > 0
	
	if not prev_falling_down and falling_down:
		latest_height = self.position.y
		jetpack_particles.emitting = false
		superjumping = false
		
	if is_on_floor():
		jetpack_particles.emitting = false
		if Input.is_action_just_pressed("ui_accept"):
			motion.y = JUMP_HEIGHT
		elif Input.is_action_pressed("left_dash") and Input.is_action_pressed("right_dash"):
			if jetpack_energy >= JETPACK_ENERGY_FOR_SUPERJUMP:
				spend_energy(JETPACK_ENERGY_FOR_SUPERJUMP)
				motion.y = SUPER_JUMP_HEIGHT
				superjumping = true
				jetpack_particles.emitting = true
			just_superjumped_l_pressed = true
			just_superjumped_r_pressed = true
	else:
		if falling_down and Input.is_action_pressed("ui_accept"):
			motion.y = lerp(motion.y, JETPACK_DOWN_SPEED, DAMPING_FALLING)
			jetpack_on = true
			jetpack_particles.emitting = true
		else:
			jetpack_on = false
			if not superjumping:
				jetpack_particles.emitting = false
	
	if just_hit:
		anim_time_hit_elapsed_time += delta
		if anim_time_hit_elapsed_time > ANIM_TIME_HIT:
			anim_time_hit_elapsed_time = 0
			just_hit = false
		else:
			sprite.play(ANIM_HIT)
	
	if superjumping:
		sprite.play(ANIM_JUMP)
	
	motion = move_and_slide(motion, UP)

func _process(delta):
	if not jetpack_on and not is_dead:
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
	shot_particles.emitting = true
	shot_particles_timer.start()
	yield(shot_particles_timer, "timeout")
	shot_particles.emitting = false

func damage():
	if not invulnerable:
		health -= 1
		emit_signal("damage_taken", health)
		if health > 0:
			invulnerable = true
			modulate = Color(1.0, 1.0, 1.0, 0.5)
			invulnerable_after_hit_timer.start()
			just_hit = true
		else:
			var explosion = Controller.explosion_scene.instance()
			explosion.position = position
			Controller.get_current_scene().add_child(explosion)
			visible = false
			is_dead = true
			emit_signal("player_died")

func spend_energy(value):
	jetpack_energy -= value
	emit_signal("energy_spent", jetpack_energy)

func _on_InvulnerableAfterHitTimer_timeout():
	invulnerable = false
	modulate = Color(1.0, 1.0, 1.0, 1)

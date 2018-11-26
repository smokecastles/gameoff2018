extends Area2D

const SPEED = 500
const Player = preload("Player.gd")
const Enemy = preload("Enemy.gd")
const Invader = preload("Invader.gd")
const explosion_scene = preload("Explosion.tscn")

const motion = Vector2()
var direction_x = 1
var direction_y = 0
var from_player = false

func _ready():
	$Sprite.play("Shoot")

func _physics_process(delta):
	motion.x = SPEED * delta * direction_x
	motion.y = SPEED * delta * direction_y
	translate(motion)
	pass

func add_explosion():
	var explosion = explosion_scene.instance()
	explosion.position = position
	Controller.get_current_scene().add_child(explosion)

func set_direction_x(direction_x):
	self.direction_x = direction_x
	if direction_x == -1:
		$Sprite.flip_h = true
	self.direction_y = 0

func set_direction_y(direction_y):
	self.direction_y = direction_y
	if direction_y == -1:
		self.rotation_degrees = 90
	else:
		self.rotation_degrees = 270
	self.direction_x = 0

func _on_VisibilityNotifier2D_screen_exited():
	# TODO allow for off-screen damage... maybe a timer?
	queue_free()

func _on_Projectile_body_entered(body):
	if body is Player:
		if from_player or body.invulnerable:
			return
		else:
			body.damage()
		
	if body is Invader:
		body.damage()
		add_explosion()
	
	queue_free()

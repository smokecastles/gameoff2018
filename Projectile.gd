extends Area2D

const SPEED = 1000
const Enemy = preload("Enemy.gd")
const explosion_scene = preload("Explosion.tscn")

const motion = Vector2()
var direction_x = 1
var direction_y = 0

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
	queue_free()

func _on_Projectile_body_entered(body):
	if body is Enemy:
		body.damage()
		add_explosion()
	queue_free()

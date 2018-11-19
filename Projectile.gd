extends Area2D

const SPEED = 1000
const Enemy = preload("Enemy.gd")
const explosion_scene = preload("Explosion.tscn")

onready var explosion_sprite = $ExplosionSprite

const motion = Vector2()
var direction = 1

func _ready():
	$Sprite.play("Shoot")

func _physics_process(delta):
	motion.x = SPEED * delta * direction
	translate(motion)
	pass

func add_explosion():
	var explosion = explosion_scene.instance()
	explosion.position = position
	Controller.get_current_scene().add_child(explosion)

func set_direction(direction):
	self.direction = direction
	if direction == -1:
		$Sprite.flip_h = true

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Projectile_body_entered(body):
	if body is Enemy:
		body.damage()
		add_explosion()
	queue_free()

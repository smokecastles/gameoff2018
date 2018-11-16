extends Area2D

const SPEED = 1000

const motion = Vector2()
var direction = 1

func set_direction(direction):
	self.direction = direction
	if direction == -1:
		$Sprite.flip_h = true

func _ready():
	$Sprite.play("Shoot")

func _physics_process(delta):
	motion.x = SPEED * delta * direction
	translate(motion)
	pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Projectile_body_entered(body):
	queue_free()
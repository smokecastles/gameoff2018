extends KinematicBody2D

onready var sprite = $AnimatedSprite
onready var collisionshape = $CollisionShape2D
export var jump_height = 2500

var used = false
var motion = Vector2()

func _ready():
	sprite.play("Idle")

func _on_Area2D_body_entered(body):	
	if not used and body.get_name() == "Player":
		used = true
		sprite.play("Activated")
		body.motion.y = -jump_height
		global_position = global_position + Vector2(0, -23) * scale
		collisionshape.disabled = true
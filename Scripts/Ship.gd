extends Area2D

const MOVE_SPEED = 200

var velocity = Vector2()

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = -MOVE_SPEED*delta
	elif Input.is_action_pressed("ui_right"):
		velocity.x = MOVE_SPEED*delta
	else:
		velocity.x = 0
		
	if Input.is_action_pressed("ui_up"):
		velocity.y = -MOVE_SPEED*delta
	elif Input.is_action_pressed("ui_down"):
		velocity.y = MOVE_SPEED*delta
	else:
		velocity.y = 0
		
	position += velocity
	pass

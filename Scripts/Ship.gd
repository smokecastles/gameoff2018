extends Area2D

const MOVE_SPEED = 200
const interval_shot = 0.2
const scn_laser = preload("res://scenes/laser.tscn")

var velocity = Vector2()
var timer_shot = 0
onready var size = get_node("sprite").texture.get_size()


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
		
	if Input.is_key_pressed(32) && timer_shot <= 0:
		shoot()
	
	timer_shot -= delta;
	position += velocity
	position.x = clamp(position.x,0+size.x/2, get_viewport().get_visible_rect().size.x-size.x/2)
	position.y = clamp(position.y,0+size.y/2, get_viewport().get_visible_rect().size.y-size.y/2)
	pass
	
func shoot():
	timer_shot = interval_shot
	var pos_left = get_node("cannons/left").global_position
	var pos_right= get_node("cannons/right").global_position
	create_laser(pos_left)
	create_laser(pos_right)
	pass
	

func create_laser(pos):
	var laser = scn_laser.instance()
	laser.position = pos
	get_tree().get_root().add_child(laser)
	pass
extends Area2D

const MOVE_SPEED = 200
const interval_shot = 0.2
export var armor = 4 setget set_armor
const scn_laser = preload("res://Scenes/laser_ship.tscn")
const scn_explosion = preload("res://Scenes/explosion.tscn")
const scn_flash = preload("res://Scenes/flash.tscn")

var velocity = Vector2()
var timer_shot = 0
onready var size = get_node("sprite").texture.get_size()
onready var anim = get_node("anim")
onready var camera = get_node("/root/space_shooter/camera_shake")
onready var gui = get_node("/root/space_shooter/CanvasLayer/GUI")
onready var audio_player = get_node("/root/space_shooter/audio_player")
onready var controller = get_node("/root/space_shooter")


# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	add_to_group("ship")
	
	size.x = size.x * get_node("sprite").scale.x
	size.y = size.y * get_node("sprite").scale.y
	pass

func _process(delta):
	if (Controller.playing == false):
		return
	
	var is_idle = true
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = -MOVE_SPEED*delta
		anim.play("left")
		is_idle = false
	elif Input.is_action_pressed("ui_right"):
		velocity.x = MOVE_SPEED*delta
		anim.play("right")
		is_idle = false
	else:
		velocity.x = 0
		
	if Input.is_action_pressed("ui_up"):
		velocity.y = -MOVE_SPEED*delta
		anim.play("up")
		is_idle = false
	elif Input.is_action_pressed("ui_down"):
		velocity.y = MOVE_SPEED*delta
		anim.play("down")
		is_idle = false
	else:
		velocity.y = 0
	
	if is_idle == true:
		anim.play("idle")
		
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
	audio_player.play_sfx("player_shoot")
	pass
	
func set_armor(new_value):
		
	if (Controller.playing == false):
		return
		
	if new_value < armor:
		get_tree().get_root().add_child(scn_flash.instance())
		audio_player.play_sfx("player_hit")
	
	if(gui !=  null):
		gui.update_health(new_value)
	
	armor = new_value
	if armor <= 0:
		camera.shake(8, 0.13)
		create_explosion()
		gui._on_Player_player_died()
		queue_free()
	pass
	

func create_laser(pos):
	var laser = scn_laser.instance()
	laser.position = pos
	get_tree().get_root().add_child(laser)
	pass
	
func create_explosion():
	var explosion = scn_explosion.instance()
	explosion.position = position
	get_tree().get_root().add_child(explosion)
	audio_player.play_sfx("player_explosion")
	pass
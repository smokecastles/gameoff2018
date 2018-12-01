extends "res://scripts/enemy.gd"

const scn_laser = preload("res://scenes/laser_enemy.tscn")

onready var gui = get_node("/root/space_shooter/CanvasLayer/GUI")
onready var boss_animation = get_node("boss_animation")
onready var mega_laser_animation = get_node("mega_laser_animation")
onready var mega_laser_area = get_node("Position2D/mega_laser_area")

var can_be_damaged = false
var moving = false

var wr_audio_player;

onready var cannons = { 0 :get_node("right_cannon_ext"),
1 :get_node("right_cannon_int"),
2 :get_node("left_cannon_ext"),
3 :get_node("left_cannon_int"),
	}

func _ready():
	set_process(true)
	remove_from_group("enemy")
	add_to_group("boss")
	mega_laser_area.add_to_group("laser")
	connect("area_entered", self, "_on_area_enter")
	mega_laser_area.connect("area_entered", self, "_on_area_enter")
	moving = false
	can_be_damaged = false
	size.x = size.x * get_node("sprite").scale.x
	size.y = size.y * get_node("sprite").scale.y
	mega_laser_animation.play("inactive")
	gui = get_node("/root/space_shooter/CanvasLayer/GUI")
	audio_player = get_node("/root/space_shooter/audio_player")
	wr_audio_player = weakref(audio_player);
	pass

func do_animation_intro():
	boss_animation.play("intro_boss")
	audio_player.play_music("final_boss_theme")
	pass

func start_boss_battle():
	can_be_damaged = true
	moving = true
	boss_animation.play("idle")
	shoot()
	shoot_mega_laser()
	pass

func _process(delta):
	if (moving == false):
		return
		
	if(velocity.x >0):
		boss_animation.play("turn_right")
	else:
		boss_animation.play("turn_left")
		
	if position.x <= 0 + size.x/3:
		velocity.x = abs(velocity.x)
			
	if position.x >= get_viewport().get_visible_rect().size.x - size.x/3:
		velocity.x = -abs(velocity.x)
			
	pass
	
func _on_area_enter(other):
	if other.is_in_group("ship"):
		other.armor -= 1
		if(camera != null):
			camera.shake(3, 0.13)
	if other.is_in_group("enemy"):
		other.armor = 0 
	pass

func set_armor(new_value):
	if new_value < armor:
		if(can_be_damaged == false):
			return
		if(wr_audio_player.get_ref()):
			audio_player.play_sfx("enemy_hit")
		else:
			queue_free()
		
	if(gui !=  null):
		gui.update_health_boss(new_value)
		
	if is_queued_for_deletion():
		return
	armor = new_value
	if armor <=0: 
		moving = false
		create_explosion()
		gui._on_player_won()
		queue_free()
	pass

func shoot():
	while true:
		for i in range(0, cannons.size()):
			if(wr_audio_player.get_ref()):
				audio_player.play_sfx("enemy_shoot")
			else:
				queue_free()
				return
			
			var laser = scn_laser.instance()
			laser.position = cannons[i].global_position
			get_tree().get_root().add_child(laser)
		
		yield(get_tree().create_timer(1.5), "timeout")
	pass
	
func shoot_mega_laser():
	while true:
		mega_laser_animation.play("inactive")
		yield(get_tree().create_timer(3), "timeout")
		mega_laser_animation.play("warning")
		yield(get_tree().create_timer(3), "timeout")
		mega_laser_animation.play("active")
		yield(get_tree().create_timer(3), "timeout")
	pass

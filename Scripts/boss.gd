extends "res://scripts/enemy.gd"

onready var gui = get_node("/root/space_shooter/CanvasLayer/GUI")

var can_be_damaged = false
var moving = false

func do_animation_intro():
	var boss_animation = get_node("boss_animation")
	boss_animation.play("intro_boss")
	pass

func start_boss_battle():
	can_be_damaged = true
	moving = true
	pass

func _process(delta):
	if (moving == true):
		if position.x <= 0 + size.x/2:
			velocity.x = abs(velocity.x)
		if position.x >= get_viewport().get_visible_rect().size.x - size.x/2:
			velocity.x = -abs(velocity.x)
	pass
	
func _on_area_enter(other):
	if other.is_in_group("ship"):
		other.armor -= 1
		if(camera != null):
			camera.shake(3, 0.13)
	pass

func set_armor(new_value):
	if new_value < armor:
		if(can_be_damaged == false):
			return
		audio_player.play_sfx("enemy_hit")
		
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


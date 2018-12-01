extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var start_game = false

func _ready():
	Controller.play_music()
	Controller.playing = false
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_exit"):
		Controller.goto_scene("res://MainMenu.tscn")
	if start_game == true:
		start_game = false
		Controller.playing = true
	pass


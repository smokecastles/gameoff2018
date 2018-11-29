extends MarginContainer

var position = 0

onready var newgame_label = $HBoxContainer/VBoxContainer/MenuOptions/NewGame
onready var about_label = $HBoxContainer/VBoxContainer/MenuOptions/About
onready var highlighted_theme = newgame_label.theme

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		match position:
			0: Controller.goto_scene("res://World.tscn")
	
	if Input.is_action_just_pressed("ui_down"):
		if position == 0:
			position = 1
		elif position == 1:
			position = 0
	elif Input.is_action_just_pressed("ui_up"):
		if position == 0:
			position = 1
		elif position == 1:
			position = 0
	
	if position == 0:
		newgame_label.theme = highlighted_theme
		about_label.theme = null
	elif position == 1:
		newgame_label.theme = null
		about_label.theme = highlighted_theme
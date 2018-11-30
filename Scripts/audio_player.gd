extends Node

const sfx_sound = preload("res://Scenes/sfx.tscn")
onready var music_player = get_node("music_player")

var sfx_library = { "player_shoot": preload("res://Sounds/sfx/P1-DISPARO.ogg"),
"player_hit": preload("res://Sounds/sfx/P1-HIT.ogg"),
"player_explosion": preload("res://Sounds/sfx/P1-DESTRUIDO.ogg"),
"enemy_shoot": preload("res://Sounds/sfx/NAVE-DISPARO.ogg"),
"enemy_hit": preload("res://Sounds/sfx/NAVE-HIT.ogg"),
"enemy_explosion": preload("res://Sounds/sfx/NAVE-DESTRUIDA.ogg"),
}

var music_library ={"main_theme_loop": preload("res://Sounds/music/TEMA2-SIN-INTRO.ogg")}

func play_music(var music):
	if music_library.has(music):
		var stream = music_library[music]
		music_player.stream = stream
		music_player.play()
	pass

func play_sfx(var sound):
	if sfx_library.has(sound):
		var stream = sfx_library[sound]
		var sfx = sfx_sound.instance()
		get_tree().get_root().add_child(sfx)
		sfx.stream = stream
		sfx.position = music_player.position
		sfx.play()
	pass

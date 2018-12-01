extends Node

onready var music_player = get_node("music_player")
onready var sfx_player = preload("res://Scenes/sfx.tscn")
onready var sfx_player_w_loop = get_node("sfx_player_w_loop")

var sfx_library = {
	"player_shoot": preload("res://Sounds/sfx/P1-DISPARO.ogg"),
	"player_hit": preload("res://Sounds/sfx/P1-HIT.ogg"),
	"player_explosion": preload("res://Sounds/sfx/P1-DESTRUIDO.ogg"),
	"player_jetpack": preload("res://Sounds/sfx/P1-JETPACK.ogg"),
	"player_death": preload("res://Sounds/sfx/P1-MUERTE.ogg"),
	"player_jump": preload("res://Sounds/sfx/P1-SALTO.ogg"),
	"player_falling": preload("res://Sounds/sfx/fall.ogg"),
	"enemy_shoot": preload("res://Sounds/sfx/NAVE-DISPARO.ogg"),
	"enemy_hit": preload("res://Sounds/sfx/NAVE-HIT.ogg"),
	"enemy_explosion": preload("res://Sounds/sfx/NAVE-DESTRUIDA.ogg"),
}

var music_library = {
	"platformer_loop": preload("res://Sounds/music/TEMA1.ogg"),
	"shooter_theme_loop": preload("res://Sounds/music/TEMA2-SIN-INTRO.ogg"),
	"shooter_theme": preload("res://Sounds/music/TEMA2.ogg"),
	"final_boss_theme": preload("res://Sounds/music/final_boss.ogg")
}

func play_music(var music):
	if music_library.has(music):
		var stream = music_library[music]
		music_player.stream = stream
		music_player.play()

func stop_music():
	music_player.stop()

func play_sfx(var sound):
	if sfx_library.has(sound):
		var stream = sfx_library[sound]
		var sfx = sfx_player.instance()
		get_tree().get_root().add_child(sfx)
		sfx.stream = stream
		if sound in ["player_explosion", "enemy_explosion"]:
			sfx.volume_db = 0
		sfx.play()
	
func play_sfx_w_loop(var sound):
	if sfx_library.has(sound) and not sfx_player_w_loop.playing:
		var stream = sfx_library[sound]
		sfx_player_w_loop.stream = stream
		sfx_player_w_loop.play()

func stop_sfx_w_loop():
	sfx_player_w_loop.stop()
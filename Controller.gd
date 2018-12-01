extends Node

var projectile = preload("res://ProjectileEnemy.tscn")
var projectile_player = preload("res://ProjectilePlayer.tscn")
var explosion_scene = preload("Explosion.tscn")

export var playing = false

var current_scene = null

func _ready():
	get_current_scene()
	#play_music()
	pass

func get_audio_player():
	return get_current_scene().get_node("audio_player")

func play_music():
	var audio_player = get_audio_player()
	var nameScene = get_current_scene().get_name()
	if(nameScene == "space_shooter"):
		audio_player.play_music("shooter_theme")
		yield(audio_player.music_player, "finished")
		audio_player.play_music("shooter_theme_loop")
	elif nameScene == "World":
		audio_player.play_music("platformer_loop")

func play_sfx(sound):
	get_audio_player().play_sfx(sound)

func play_sfx_w_loop(sound):
	get_audio_player().play_sfx_w_loop(sound)

func stop_sfx_w_loop():
	get_audio_player().stop_sfx_w_loop()

func get_current_scene():
	if not current_scene:
		var root = get_tree().get_root()
		current_scene = root.get_child(root.get_child_count() -1)
	return current_scene

func reload_current_scene():
	if(current_scene == null):
		get_current_scene()
	current_scene.get_tree().reload_current_scene()
	current_scene = null

func goto_scene(path):
    # This function will usually be called from a signal callback,
    # or some other function from the running scene.
    # Deleting the current scene at this point might be
    # a bad idea, because it may be inside of a callback or function of it.
    # The worst case will be a crash or unexpected behavior.

    # The way around this is deferring the load to a later time, when
    # it is ensured that no code from the current scene is running:

    call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
    # Immediately free the current scene,
    # there is no risk here.
    current_scene.free()

    # Load new scene.
    var s = ResourceLoader.load(path)

    # Instance the new scene.
    current_scene = s.instance()

    # Add it to the active scene, as child of root.
    get_tree().get_root().add_child(current_scene)

    # Optional, to make it compatible with the SceneTree.change_scene() API.
    get_tree().set_current_scene(current_scene)
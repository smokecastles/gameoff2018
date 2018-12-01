extends Node

var projectile = preload("res://ProjectileEnemy.tscn")
var projectile_player = preload("res://ProjectilePlayer.tscn")
var explosion_scene = preload("Explosion.tscn")
onready var audio_player = get_node("audio_player")

var current_scene = null

func _ready():
	get_current_scene()
	audio_player = get_node("audio_player")
	play_music()
	pass
	
func play_music():
	var nameScene = get_tree().get_current_scene().get_name()
	if(get_tree().get_current_scene().get_name() == "space_shooter"):
		audio_player.play_music("main_theme_loop")
	pass

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
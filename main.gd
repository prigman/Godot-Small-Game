extends Node3D

const MOB_SCENE = preload("res://mob.tscn")

func _ready():
	#randomize()
	pass

func _unhandled_input(event):
	if event.is_action_pressed("space") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene()

func _on_mob_timer_timeout():
	var mob = MOB_SCENE.instantiate()
	var mob_spawn_loc = $SpawnPath/SpawnLocation
	mob_spawn_loc.progress_ratio = randf()
	var player_pos = $Player.position
	mob.initialize(mob_spawn_loc.position, player_pos)
	add_child(mob)
	mob.squashed.connect($UserInterface/Label._on_mob_squashed)

func _on_player_hit():
	$MobTimer.stop()
	$UserInterface/Retry.show()

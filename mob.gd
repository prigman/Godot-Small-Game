extends CharacterBody3D

signal squashed

var min_speed = 2.0
var max_speed = 5.0


func _physics_process(_delta):
	move_and_slide()
	
func initialize(start_pos, player_pos):
	look_at_from_position(start_pos, Vector3(player_pos.x, 0.0, start_pos.z), Vector3.UP)
	rotate_y(randf_range(-PI / 4.0, PI / 4.0))
	var random_speed = randf_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)

func squash():
	squashed.emit()
	queue_free()

func _on_visible_on_screen_notifier_3d_screen_exited():
	queue_free()

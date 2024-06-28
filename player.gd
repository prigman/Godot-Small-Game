extends CharacterBody3D

signal hit
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var pivot = $Pivot
var bounce_impulse = 4.5
var gravity = 15

func _physics_process(delta):
	velocity.y -= gravity * delta

	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		pivot.basis = Basis.looking_at(direction, Vector3.UP)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			if Vector3.UP.dot(collision.get_normal()) > 0:
				mob.squash()
				velocity.y = bounce_impulse
				break
	pivot.rotation.x = PI / 6 * velocity.y / JUMP_VELOCITY

func die():
	hit.emit()
	queue_free()

func _on_area_3d_body_entered(_body):
	die()

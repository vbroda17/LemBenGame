extends Node3D
@export var speed := 5.0
@onready var anim_controller := $AnimationController

func _physics_process(delta):
	var input_dir = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	)

	var direction = Vector3(input_dir.x, 0, input_dir.y)

	if direction.length() > 0.1:
		# Move
		direction = (global_transform.basis * direction).normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

		# Play walking animation
		anim_controller.play("Walk")

	else:
		# No movement → idle animation
		velocity.x = lerp(velocity.x, 0.0, 0.2)
		velocity.z = lerp(velocity.z, 0.0, 0.2)
		anim_controller.play("Idle")

	move_and_slide()

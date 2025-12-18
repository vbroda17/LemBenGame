extends CharacterBody3D

# For camera
# how muc the mouse moves
# Convert that into a 3d rotation
# Add code to only rotate the camera when the mouse is in the game
# Add a spring arm node to prevent the camera from penetrating the walls
# For movement
# Get input vector, extract forward and right direction vectors, calculate the move direction, calculate character velocity, move the character

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25

@export_group("Movement")
@export var move_speed := 18.0
@export var acceleration := 40.0
@export var rotation_speed := 6.0

var _camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.BACK

@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _camera: Camera3D = %Camera3D
@onready var _skin: low_base = %low_base

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED	# Mouse is bound to game window, only when gave is active mouse is looked at
	)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity
		

func _physics_process(delta: float) -> void:
	_camera_pivot.rotation.x += _camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, -PI / 6.0, PI / 3.0) #  -PI / 6.0 is -30 degrees, PI / 3.0 is 60 degrees
	_camera_pivot.rotation.y -= _camera_input_direction.x * delta

	_camera_input_direction = Vector2.ZERO

	var raw_input := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x

	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	move_and_slide()
	
	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	_skin.global_rotation.y = lerp_angle(_skin.rotation.y, target_angle, rotation_speed * delta)

	var ground_speed := velocity.length()
	if ground_speed > 0.0 and ground_speed < 5.0:
		_skin.walk()
	elif ground_speed >= 5.0:
		_skin.running()
	else:
		_skin.idle()

class_name low_base extends Node3D

@onready var animation_tree = %AnimationTree
@onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")
#@onready var move_tilt_path : String = "parameters/StateMachine/Move/tilt/add_amount"

#var run_tilt = 0.0 : set = _set_run_tilt



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#func _set_run_tilt(value : float):
	#run_tilt = clamp(value, -1.0, 1.0)
	#animation_tree.set(move_tilt_path, run_tilt)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func idle():
	state_machine.travel("Idle1")

func walk():
	state_machine.travel("walking")

func running():
	state_machine.travel("running")

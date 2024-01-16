extends Node3D

var ball_scene = preload("res://Scenes/ball.tscn")
var have_ball:bool = false
var ball:Ball = null
@export var my_force:Vector3 = Vector3(0,0,0)
@export var my_rot: Vector3 = Vector3(0,0,0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_ball()
	pass # Replace with function body.

func spawn_ball():
	ball = ball_scene.instantiate()
	add_child(ball)
	

func launch_ball(force:Vector3,rotation:Vector3):
	ball.freeze = false
	ball.apply_central_impulse(force)
	ball.apply_torque_impulse(rotation)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if(event is InputEventKey):
		var key_evt:InputEventKey = event
		if(key_evt.is_pressed() and key_evt.keycode == KEY_SPACE):
			launch_ball(my_force,my_rot)
			var t = create_tween()
			t.tween_interval(1)
			t.tween_callback(spawn_ball)
		

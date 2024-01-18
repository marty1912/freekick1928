extends Node3D

var ball_scene = preload("res://Scenes/ball.tscn")
var have_ball:bool = false
var my_ball:Ball = null
@export var my_force:Vector3 = Vector3(0,0,0)
@export var my_rot: Vector3 = Vector3(0,0,0)
var my_direction:Vector3 = Vector3(0,0,0)
@onready var path_3d: Path3D = $Path3D

var rotation_mult: float = 20

func set_direction(position_hit:Vector2):
	# position hit shows us where we hit the ball when we kick it
	var starting_point = Vector3(position_hit.x,position_hit.y,-1).normalized()
	var ending_point = Vector3(0,0,0)
	my_direction =  (ending_point-starting_point).normalized()

func set_position_hit(position_hit:Vector2):
	#set_direction(position_hit)
	#return
	# position hit shows us where we hit the ball when we kick it
	var starting_point = Vector3(position_hit.x,position_hit.y,-1).normalized()
	var ending_point = Vector3(0,0,0)
	my_rot =(Vector3(position_hit.y,position_hit.x,0.0))*rotation_mult
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	my_ball = spawn_ball()
	pass # Replace with function body.

func spawn_ball() ->Ball:
	var ball = ball_scene.instantiate()
	add_child(ball)
	return ball
	

func launch_ball(ball:Ball,force:Vector3,rot:Vector3):
	ball.stopped = false
	#ball.apply_central_impulse(force)
	#ball.apply_torque_impulse(rotation)
	ball.apply_impulse(force)
	ball.apply_rotation(my_rot)

func ball_preview(delta:float):
	my_ball.disableCollisions()
	var ball = spawn_ball()
	launch_ball_with_current_settings(ball)
	path_3d.curve.clear_points()
	for i in range(0,25):
		ball.simulate_physics(delta)
		path_3d.curve.add_point(ball.position)
		#print("ball_pos: {x}".format({"x":ball.position}))
	ball.queue_free()
	
	my_ball.enableCollisions()
	

func launch_ball_with_current_settings(ball:Ball):
	# top speed with 20 here is 180 km/h. could be max force
	# min should be like 45km/h (use 5 here) 
	my_force = 10*my_direction
	launch_ball(ball,my_force,my_rot)
	
func _physics_process(delta: float) -> void:
	ball_preview(delta)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if(event is InputEventKey):
		var key_evt:InputEventKey = event
		if(key_evt.is_pressed() and key_evt.keycode == KEY_SPACE):
			launch_ball_with_current_settings(my_ball)
			var t = create_tween()
			t.tween_interval(1)
			t.tween_callback(func(): my_ball = spawn_ball())
		

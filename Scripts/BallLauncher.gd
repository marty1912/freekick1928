extends Node3D

var ball_scene = preload("res://Scenes/ball.tscn")
var have_ball:bool = false
var my_ball:Ball = null
@export var my_force:Vector3 = Vector3(0,0,0)
@export var my_rot: Vector3 = Vector3(0,0,0)
var my_direction:Vector3 = Vector3(0,0,0)
@onready var path_3d: Path3D = $Path3D
var my_power:float = 0
var power_max:float = 20
var power_min:float = 5
var rotation_mult: float = 20
@onready var power_select: PowerSelect = $power_control/Sprite3D/power_select/PowerSelect


signal on_disable_all_inputs()
signal on_enable_all_inputs()

func set_relative_power(val:float):
	
	my_power = lerpf(power_min,power_max,val)


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
	

func disable_all_inputs():
	on_disable_all_inputs.emit()

func enable_all_inputs():
	on_enable_all_inputs.emit()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	my_ball = spawn_ball()
	power_select.on_power_select_start.connect(on_start_selecting_power)
	power_select.on_power_selected.connect(on_done_selecting_power)
	pass # Replace with function body.

func on_start_selecting_power():
	return
func on_abort_selecting_power():
	return
	
func on_done_selecting_power():
	launch_ball_with_current_settings(my_ball)

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
	my_force = my_power*my_direction
	launch_ball(ball,my_force,my_rot)
	
func _physics_process(delta: float) -> void:
	ball_preview(delta)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	#print("action: {x}".format({"x":event.as_text()}))
	if(event.is_action_pressed("ball_fire")):
		power_select.on_ball_fire_pressed()
	return
	if(event is InputEventKey):
		var key_evt:InputEventKey = event
		if(key_evt.is_pressed() and key_evt.keycode == KEY_SPACE):
			launch_ball_with_current_settings(my_ball)
			var t = create_tween()
			t.tween_interval(1)
			t.tween_callback(func(): my_ball = spawn_ball())
		

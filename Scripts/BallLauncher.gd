class_name BallLauncher extends Node3D

var ball_scene = preload("res://Scenes/ball.tscn")
var have_ball:bool = false
var my_ball:Ball = null
@export var my_force:Vector3 = Vector3(0,0,0)
@export var my_rot: Vector3 = Vector3(0,0,0)
var my_direction:Vector3 = Vector3(0,0,0)
@onready var path_3d: Path3D = $Path3D
var my_power:float = 0
var power_max:float = 20
var power_min:float = 10
var rotation_mult_x: float = 20
var rotation_mult_y: float = 10
@onready var power_select: PowerSelect = $CamPlatform/Camera3D/GUI/power_control/Sprite3D/power_select/PowerSelect
@onready var effet_control: UI_InputStaticBody = $CamPlatform/Camera3D/GUI/Effet_Control
@onready var aim_control: aimWASD = $WASD_Direction/SubViewport/Node2D
@onready var camera_3d: CameraFreeKick = $CamPlatform/Camera3D
var last_physics_delta:float = 0.1
var predicted_path_for_current_shot:Array[Vector3]=[]
var ball_launched = false
var launch_ball_in_next_physics = false
var actual_ball_path:Array[Vector3] = []

signal on_disable_all_inputs()
signal on_enable_all_inputs()

signal on_ball_was_fired()

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
	my_rot =(Vector3(position_hit.y*rotation_mult_y,position_hit.x*rotation_mult_x,0.0))
	

func disable_aim():
	aim_control.disable_inputs()
	effet_control.disable_inputs()
	
func enable_aim():
	aim_control.enable_inputs()
	effet_control.enable_inputs()
	
func disable_all_inputs():
	aim_control.disable_inputs()
	effet_control.disable_inputs()
	power_select.disable_inputs()
	on_disable_all_inputs.emit()

func enable_all_inputs():
	on_enable_all_inputs.emit()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	my_ball = spawn_ball()
	power_select.on_power_select_start.connect(on_start_selecting_power)
	power_select.on_power_selected.connect(on_done_selecting_power)
	power_select.on_power_select_abort.connect(on_abort_selecting_power)
	pass # Replace with function body.

func on_start_selecting_power():
	disable_aim()
	return
	
func on_abort_selecting_power():
	enable_aim()
	return
	
func predict_shot_before_fire(use_debug=false):
	
	my_ball.disableCollisions()
	var ball = spawn_ball()
	ball.print_debug = use_debug
	launch_ball_with_current_settings(ball)
	var old_path = predicted_path_for_current_shot.slice(0,100)
	predicted_path_for_current_shot.clear()
	for i in range(0,300):
		if(i<len(old_path) and i < 10):
			pass
			#print("old path: {x} new path: {y}".format({"x":old_path[i],"y":ball.global_position}))
		predicted_path_for_current_shot.append(ball.global_position)
		ball.simulate_physics(last_physics_delta)
		#print("ball_pos: {x}".format({"x":ball.position}))
	ball.disableCollisions()
	ball.queue_free()
	my_ball.enableCollisions()
	
	
func on_done_selecting_power():
	#predict_shot_before_fire()
	launch_ball_in_next_physics = true
	ball_launched = false

func spawn_ball() ->Ball:
	var ball = ball_scene.instantiate()
	add_child(ball)
	ball.position = Vector3(0,0,0)
	return ball
	

func launch_ball(ball:Ball,force:Vector3,rot:Vector3):
	ball.stopped = false
	var my_rotation = global_rotation
	
	ball.apply_impulse(force.rotated(Vector3(0,1,0),my_rotation.y))
	ball.apply_rotation(my_rot)

func ball_preview(delta:float):
	my_ball.disableCollisions()
	remove_child(my_ball)
	var ball = spawn_ball()
	launch_ball_with_current_settings(ball)
	path_3d.curve.clear_points()
	for i in range(0,100):
		path_3d.curve.add_point(ball.position)
		ball.simulate_physics(delta)
		#print("ball_pos: {x}".format({"x":ball.position}))
	ball.disableCollisions()
	ball.queue_free()
	add_child(my_ball)
	my_ball.enableCollisions()

func launch_ball_for_real():
	#predict_shot_before_fire()
	#predict_shot_before_fire()
	#predict_shot_before_fire()
	print("preview: ")
	predict_shot_before_fire(false)
	print("real")
	my_ball.disableCollisions()
	my_ball.queue_free()
	my_ball = spawn_ball()
	launch_ball_with_current_settings(my_ball)
	my_ball.print_debug = false
	my_ball.simulate_physics(last_physics_delta)
	on_ball_was_fired.emit()
	camera_3d.on_ball_launch(my_ball)
	print("launched ball!")
	
		

func launch_ball_with_current_settings(ball:Ball):
	# top speed with 20 here is 180 km/h. could be max force
	# min should be like 45km/h (use 5 here) 
	my_force = my_power*my_direction
	launch_ball(ball,my_force,my_rot)
	
func _physics_process(delta: float) -> void:
	last_physics_delta = delta
	if(not ball_launched):
		ball_preview(delta)
	if(launch_ball_in_next_physics and not ball_launched):
		launch_ball_for_real()
		ball_launched = true
		
		
	if(ball_launched):
		return
		if(len(actual_ball_path) < 100):
			actual_ball_path.append(my_ball.global_position)
			var i = len(actual_ball_path)-1
			print("append_ to path: {i}: {x} , {y}".format({"i":i,"x":actual_ball_path[i],"y":predicted_path_for_current_shot[i]}))
			print("break : {x}".format({"x":delta}))
		else:
			pass
			for i in range(0,len(actual_ball_path)):
				if(actual_ball_path[i] != predicted_path_for_current_shot[i]):
					pass
					#print("difference in paths! {i}: {x} , {y}".format({"i":i,"x":actual_ball_path[i],"y":predicted_path_for_current_shot[i]}))
		
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
		

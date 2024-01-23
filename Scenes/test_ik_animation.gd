class_name Goalie_Control extends Node2D


@export var targets:Array[Node2D] = []
@export var legs:Array[Node2D] = []
@export var goalie_base:Node2D
@onready var line_2d: Line2D = $"../Line2D"

@export var stop_at_y:float = 600
@export var goalie_reach:Node2D
@onready var reach_position_debug: Sprite2D = $"../reach_position_debug"

var trajectory_vel:Vector2 = Vector2(0,0)
@export var vel_max:float = 1000.0
var my_gravity:float = 980*2
var starting_position:Vector2 = Vector2(0,0)
var time_passed:float = 0.0
@onready var jump_target: Sprite2D = $"../jump_target"

@export var goalie_radius:float = 200
var legs_positions_default:Array[Vector2]= []
var targets_positions_default:Array[Vector2] = []
var goalie_default_y:float = 0
@export var golie_starting_x:float = 0

var legs_positions_start_global:Array[Vector2] = []
var in_jump:bool = false
var jump_done:bool = false
var reaction_time:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#start_jump()
	pass # Replace with function body.

func start_jump():
	var dist_to_reach:float = (goalie_base.global_position - goalie_reach.global_position).length()
	var offset = (goalie_base.global_position- global_position).normalized()*dist_to_reach
	var goalie_base_target = global_position+offset
	goalie_default_y = goalie_base.global_position.y
	
	targets_positions_default.clear()
	legs_positions_default.clear()
	legs_positions_start_global.clear()
	
	for i in targets:
		var t:Tween = create_tween()
		targets_positions_default.append(i.position)
		t.tween_property(i,"position",-offset,0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	for i in legs:
		var t:Tween = create_tween()
		legs_positions_start_global.append(i.global_position)
		legs_positions_default.append(i.position)
		#t.tween_property(i,"global_position",i.global_position,5.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	
	# formula for trajectory:
	# https://www.omnicalculator.com/physics/trajectory-projectile-motion
	# y = h + xtan(α) - gx²/2V₀²cos²(α)
	# x= V.x * t
	# y = h+ V.y*t - (g*t*t)/2
	var time_needed = get_time_to_arrive(goalie_base.global_position,goalie_base_target)
	set_trajectory_params(goalie_base.global_position,goalie_base_target,time_needed)
	debug_trajectory_line()
	in_jump = true
	jump_done = false
	time_passed = 0

func get_jump_target() -> Vector2:
	var dist_to_reach:float = (goalie_base.global_position - goalie_reach.global_position).length()
	var offset = (goalie_base.global_position- global_position).normalized()*dist_to_reach
	var goalie_base_target = global_position+offset
	
	return goalie_base_target
	
func debug_trajectory_line():
	# debug trajectory line
	line_2d.clear_points()
	var prec = 60
	var total_time = 5.0
	for i in range(0,prec):
		var pos = get_position_on_trajectory((i as float / prec)*total_time)
		
		line_2d.add_point((pos))
	return

func set_trajectory_params(start:Vector2, target:Vector2, time_arrive:float):
	jump_target.global_position = target
	starting_position = start
	var diff = (target-start)
	trajectory_vel.x = diff.x/time_arrive
	trajectory_vel.y = (diff.y-(my_gravity*time_arrive*time_arrive*0.5))/time_arrive

func get_position_on_trajectory(cur_time:float) -> Vector2:
	var x = trajectory_vel.x * cur_time
	var y = trajectory_vel.y*cur_time+(my_gravity*cur_time*cur_time)/2
	return Vector2(x,y)+starting_position


# Called every frame. 'delta' is the elapsed time since the previous frame.

func update_jump_position():
	goalie_base.global_position = get_position_on_trajectory(time_passed)
	for i in range(0,len(legs)):
		legs[i].global_position = legs_positions_start_global[i]

func stand_up():
	for i in range(0,len(targets)):
		var t :Tween = create_tween()
		t.tween_property(targets[i],"position",targets_positions_default[i],1.0)
	for i in range(0,len(legs)):
		var t :Tween = create_tween()
		t.tween_property(legs[i],"position",legs_positions_default[i],1.0)
	var t:Tween = create_tween()
	var pos_target = goalie_base.global_position
	pos_target.y = goalie_default_y
	t.tween_property(goalie_base,"global_position",pos_target,1.0)
	t.tween_callback(func(): jump_done = false)
	t.tween_callback(func(): in_jump = false)

func _process(delta: float) -> void:
	time_passed += delta
	if(in_jump and not jump_done):
		if(goalie_base.global_position.y > stop_at_y):
			jump_done = true
			stand_up()
		else:
			update_jump_position()
		pass


func get_time_to_arrive(start:Vector2, target:Vector2) ->float:
	var dist = (start-target).length()
	var duration = dist/vel_max
	if(dist < 10):
		pass
		#print("duration: %f" %duration )
	return duration
	
	
func get_time_needed(jump_here:Vector2):
	self.global_position = jump_here
	var target = get_jump_target()
	
	return get_time_to_arrive(goalie_base.global_position,target)
	

func on_jump_here(jump_here:Vector2):
	self.global_position = jump_here
	start_jump()
	

func can_jump_here_in_time(jump_here:Vector2,time:float)-> bool:
	var dist_to_goalie = (jump_here-goalie_base.global_position).length()
	if(dist_to_goalie < goalie_radius):
		# no need to jump even
		return true
		
	var jump_time = get_time_needed(jump_here)
	var need_time = reaction_time+jump_time
	
	self.global_position = jump_here
	var target = get_jump_target()
	var dist = (goalie_base.global_position-target).length()
	
	if(need_time < time):
		return true
	else:
		return false

func reach_to_ball_without_jump(jump_here:Vector2):
	targets_positions_default.clear()
	legs_positions_default.clear()
	legs_positions_start_global.clear()
	goalie_default_y = goalie_base.global_position.y
	for i in targets:
		var t:Tween = create_tween()
		targets_positions_default.append(i.position)
		t.tween_property(i,"global_position",jump_here,0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	for i in legs:
		var t:Tween = create_tween()
		legs_positions_start_global.append(i.global_position)
		legs_positions_default.append(i.position)
	
	var t:Tween = create_tween()
	t.tween_interval(2.0)
	t.tween_callback(func(): stand_up())

func jump_to_be_here_in(jump_here:Vector2,time:float) -> bool:
	reach_position_debug.global_position = jump_here
	var dist_to_goalie = (jump_here-goalie_base.global_position).length()
	if(dist_to_goalie < goalie_radius):
		# no need to jump even
		reach_to_ball_without_jump(jump_here)
		return true
		
	var jump_time = get_time_needed(jump_here)
	var need_time = reaction_time+jump_time
	if(can_jump_here_in_time(jump_here,time)):
		var diff = time -need_time
		print("need time: {x} have {to_spare} to spare".format({"x":need_time,"to_spare":diff}))
		var t:Tween = create_tween()
		t.tween_interval(diff)
		t.tween_callback(func(): on_jump_here(jump_here))
		return true
	else:
		var t:Tween = create_tween()
		t.tween_interval(reaction_time)
		t.tween_callback(func(): on_jump_here(jump_here))
		return false

class_name Goalie_Control extends Node2D


@export var targets:Array[Node2D] = []
@export var legs:Array[Node2D] = []
@export var goalie_base:Node2D
@onready var line_2d: Line2D = $"../Line2D"

@export var stop_at_y:float = 600
@export var goalie_reach:Node2D

var trajectory_vel:Vector2 = Vector2(0,0)
@export var vel_max:float = 1000.0
var my_gravity:float = 980*2
var starting_position:Vector2 = Vector2(0,0)
var time_passed:float = 0.0
@onready var jump_target: Sprite2D = $jump_target

var legs_positions_default:Array[Vector2]= []
var targets_positions_default:Array[Vector2] = []
var goalie_default_y:float = 0
@export var golie_starting_x:float = 0

var legs_positions_start_global:Array[Vector2] = []
var in_jump:bool = false
var jump_done:bool = false

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
	return duration
	
	
func get_time_needed(jump_here:Vector2):
	self.global_position = jump_here
	var target = get_jump_target()
	return get_time_to_arrive(goalie_base.global_position,target)
	

func on_jump_here(jump_here:Vector2):
	self.global_position = jump_here
	start_jump()
	

func jump_to_be_here_in(jump_here:Vector2,time:float) -> bool:
	var need_time = get_time_needed(jump_here)
	if(need_time < time):
		var diff = time -need_time
		var t:Tween = create_tween()
		t.tween_interval(diff)
		t.tween_callback(func(): on_jump_here(jump_here))
		return true
	else:
		on_jump_here(jump_here)
		return false

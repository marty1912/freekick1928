extends Node2D


@export var targets:Array[Node2D] = []
@export var legs:Array[Node2D] = []
@export var goalie_base:Node2D
@onready var line_2d: Line2D = $Line2D
@export var stop_at_y:float = 600

var trajectory_vel:Vector2 = Vector2(0,0)
@export var vel_max:float = 10.0
var my_gravity:float = 980
var starting_position:Vector2 = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for i in targets:
		var t:Tween = create_tween()
		t.tween_property(i,"global_position",global_position,0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	for i in legs:
		var t:Tween = create_tween()
		t.tween_property(i,"global_position",i.global_position,5.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	var tween_base:Tween = create_tween()
	tween_base.tween_interval(0.0)
	
	var offset = (goalie_base.global_position- global_position).normalized()*300
	var goalie_base_target = global_position+offset
	#tween_base.tween_property(goalie_base,"global_position",goalie_base_target,1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	var my_height = 600
	var fall_down_target = Vector2(goalie_base_target.x-offset.x * 1,my_height)
	#tween_base.tween_property(goalie_base,"global_position",fall_down_target,1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	# formula for trajectory:
	# https://www.omnicalculator.com/physics/trajectory-projectile-motion
	# y = h + xtan(α) - gx²/2V₀²cos²(α)
	# x= V.x * t
	# y = h+ V.y*t - (g*t*t)/2
	set_trajectory_params(goalie_base.global_position,goalie_base_target,0.5)
	
	line_2d.clear_points()
	var prec = 60
	var total_time = 5.0
	for i in range(0,prec):
		var pos = get_position_on_trajectory((i as float / prec)*total_time)
		
		line_2d.add_point((pos))
	pass # Replace with function body.


func set_trajectory_params(start:Vector2, target:Vector2, time_arrive:float):
	starting_position = start
	var diff = (target-start)
	trajectory_vel.x = diff.x/time_arrive
	trajectory_vel.y = (diff.y-(my_gravity*time_arrive*time_arrive))/time_arrive

func get_position_on_trajectory(cur_time:float) -> Vector2:
	var x = trajectory_vel.x * cur_time
	var y = trajectory_vel.y*cur_time+(my_gravity*cur_time*cur_time)/2
	return Vector2(x,y)+starting_position

var time_passed:float = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed += delta
	
	if(goalie_base.global_position.y > stop_at_y):
		pass
	else:
		goalie_base.global_position = get_position_on_trajectory(time_passed)
	pass

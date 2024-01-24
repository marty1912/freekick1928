extends Sprite3D



@onready var goal_keeper_scene: GoalkeeperScene = $SubViewport/GoalKeeperScene
@onready var static_body_3d: StaticBody3D = $StaticBody3D
@onready var sub_viewport: SubViewport = $SubViewport
@onready var area_3d: Area3D = $Area3D

var time_until_hit:float = 0
signal on_ball_held()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func is_behind_me(point:Vector3):
	var local_pt = to_local(point)
	if(local_pt.z > 0):
		return true
	else:
		return false
		

func get_position_on_plane(path:Array[Vector3],delta:float) -> Vector2:
	time_until_hit = 0
	var closest = Vector3(0,0,0)
	for pt in path:
		if(is_behind_me(pt)):
			break
		time_until_hit += delta
		closest = pt
	var my_resolution:Vector2 = sub_viewport.size
	var my_size_in_3d:Vector2 = sub_viewport.size *pixel_size
	var pt_local:Vector3 = to_local(closest)
	var center_point:Vector2 = my_resolution/2
	
	var x = (pt_local.x/my_size_in_3d.x)*my_resolution.x + center_point.x
	var y =  center_point.y - (pt_local.y/my_size_in_3d.y)*my_resolution.y 
	print("my_point local: {y} total: {total_y}".format({"y":pt_local.y,"total_y":y}))
	return Vector2(x,y)

func on_ball_fired(ball_launch:BallLauncher):
	var my_target:Vector2 = get_position_on_plane(ball_launch.predicted_path_for_current_shot,ball_launch.last_physics_delta)
	var held:bool = goal_keeper_scene.ball_will_reach_at(my_target,time_until_hit)
	if(held):
		static_body_3d.collision_layer = 1
		area_3d.collision_layer =1
		area_3d.collision_mask = 1
		area_3d.stop_ball_enabled = true
		print("will hold ball")
		var t :Tween = create_tween()
		t.tween_interval(time_until_hit-0.2)
		t.tween_callback(func():on_ball_held.emit())
		
	else:
		static_body_3d.collision_layer = 0
		area_3d.collision_layer =0
		area_3d.collision_mask = 0
		area_3d.stop_ball_enabled = false
		print("will not hold ball")
	pass



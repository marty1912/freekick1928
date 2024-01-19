class_name UI_InputStaticBody extends StaticBody3D


signal on_have_mouse_pos_rel(Vector2)

@export var sizeXY:Vector2 = Vector2(1,1)
@export var align_to_cam:bool = true
 
var currently_selected:bool = false
var input_disabled:bool = false

func disable_inputs():
	input_disabled = true

func enable_inputs():
	input_disabled = false

func reset_aim():
	on_have_mouse_pos_rel.emit(Vector2(0,0))

func getPositionOfMouseIn3D() -> Dictionary:
	#https://stackoverflow.com/questions/76893256/how-to-get-the-3d-mouse-pos-in-godot-4-1
	var viewport := get_viewport()
	var mouse_position := viewport.get_mouse_position()
	var camera := viewport.get_camera_3d()
	var origin := camera.project_ray_origin(mouse_position)
	var direction := camera.project_ray_normal(mouse_position)
	var ray_length := camera.far
	var end := origin + direction * ray_length
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	var result := space_state.intersect_ray(query)
	return result
	var mouse_position_3D := end
	if not result.is_empty():
		print("result keys: {x}".format({"x":result}))
		
		mouse_position_3D = result["position"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(align_to_cam):
		var z = position.z
		var z_only:Vector3 = Vector3(0,0,z)
		#https://stackoverflow.com/questions/10798954/how-to-rotate-a-vector-to-a-place-that-is-aligned-with-z-axis
		
		
		var position_before:Vector3 = position
		var camera:Camera3D = get_viewport().get_camera_3d()
		var camera_rot = camera.global_rotation
		global_rotation = camera.global_rotation
		var dist = camera.global_position-get_parent().global_position
		var ball_position_local = camera.to_local(get_parent().global_position)
		
		var position_I_want = camera.to_global(position_before+ball_position_local)
		global_position = position_I_want
		#global_position = get_parent().global_position + dist.normalized()*z
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func getPosition2DOnMe():
	var raycast_res = getPositionOfMouseIn3D()
	if(raycast_res.is_empty()):
		#print("empty")
		return null
	if(raycast_res["collider"] == self):
		
		var mouse_position = raycast_res["position"]
		#print("collided with me! {x}, my_pos: {y}".format({"x":to_local(mouse_position),"y":self.position}))
		var offset = to_local(mouse_position)
		return Vector2(offset.x,offset.y)
	else:
		var mouse_position = raycast_res["position"]
		#print("collided with something else! {x}, my_pos: {y}".format({"x":to_local(mouse_position),"y":self.position}))
		var offset = to_local(mouse_position)
		var size_half = sizeXY/2
		var clamped = Vector2(clampf(offset.x,-size_half.x,size_half.x),clampf(offset.y,-size_half.y,size_half.y) )
		return clamped
	return null

func is_clicked_on_me() ->bool:
	var raycast_res = getPositionOfMouseIn3D()
	if(raycast_res.is_empty()):
		#print("empty")
		return false
	if(raycast_res["collider"] == self):
		return true
	else:
		return false

func _physics_process(delta: float) -> void:
	if(input_disabled):
		return
	if(not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		return
	if(not currently_selected):
		return
	var pos = getPosition2DOnMe()
	if(pos == null):
		return
	
	
	var rel_pos = Vector2(pos.x/sizeXY.x,pos.y/sizeXY.y)
	#print("pos: {x} rel pos: {y}".format({"x":pos,"y":rel_pos}))
	on_have_mouse_pos_rel.emit(rel_pos)
	
func _input(event: InputEvent) -> void:
	if(input_disabled):
		currently_selected = false
		return
	if(event is InputEventMouseButton):
		var m_evt:InputEventMouseButton = event as InputEventMouseButton
		print("mouse event:{y} is on me?: {x} -- {z}".format({"x":is_clicked_on_me(),"y":m_evt.as_text(),"z":m_evt.button_index}))
		if(m_evt.pressed  and m_evt.button_index ==1 and  is_clicked_on_me()):
			print("now active")
			currently_selected = true
		if(m_evt.is_released()):
			print("released")
			currently_selected = false
			

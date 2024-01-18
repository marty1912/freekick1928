extends StaticBody3D


signal on_have_mouse_pos_rel(Vector2)

@export var sizeXY:Vector2 = Vector2(1,1)

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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func getPosition2DOnMe():
	var raycast_res = getPositionOfMouseIn3D()
	if(raycast_res.is_empty()):
		return null
	if(raycast_res["collider"] == self):
		
		var mouse_position = raycast_res["position"]
		print("collided with me! {x}, my_pos: {y}".format({"x":to_local(mouse_position),"y":self.position}))
		var offset = to_local(mouse_position)
		return Vector2(offset.x,offset.y)
	return null


func _physics_process(delta: float) -> void:
	if(input_disabled):
		return
	if(not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		return
	var pos = getPosition2DOnMe()
	if(pos == null):
		return
	
	var rel_pos = Vector2(pos.x/sizeXY.x,pos.y/sizeXY.y)
	print("pos: {x} rel pos: {y}".format({"x":pos,"y":rel_pos}))
	on_have_mouse_pos_rel.emit(rel_pos)

@tool 
extends Node3D
# TODO: thicker lines like this https://mattdesl.svbtle.com/drawing-lines-is-hard

var my_line = null
@export var path3D:Path3D
@export var my_material : Material
func line(positions: Array[Vector3], color = Color.WHITE_SMOKE):
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material :Material= ORMMaterial3D.new()
	if(my_material != null):
		material = my_material

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	for i in range(0,len(positions)-1):
		immediate_mesh.surface_add_vertex(positions[i])
		immediate_mesh.surface_add_vertex(positions[i+1])
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	#material.albedo_color = color
	
	if(my_line != null):
		my_line.queue_free()
	my_line = mesh_instance
	add_child(my_line)

	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var my_points:Array[Vector3] = []
	if(path3D.curve.point_count > 0):
		for i in range(0,path3D.curve.point_count):
			my_points.append(path3D.curve.get_point_position(i))
		line(my_points)
	pass

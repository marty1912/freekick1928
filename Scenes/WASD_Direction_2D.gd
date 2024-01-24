class_name aimWASD extends Node2D



@onready var cam_platform: Node3D = $"../../../CamPlatform"


var my_position:Vector2 = Vector2(0,0)
var min_x: float = -0.5
var min_y: float = -0.5
var max_x: float = 0.5
var max_y:float = -0.1

var moveSpeed:float = 0.25
signal on_have_position(Vector2)

var input_disabled:bool = false

func disable_inputs():
	input_disabled = true

func enable_inputs():
	input_disabled = false

func reset_aim():
	my_position = Vector2(lerpf(min_x,max_x,0.5),lerpf(min_y,max_y,0.5))
	on_have_position.emit(my_position)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_aim()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(input_disabled):
		return
	var movement:Vector2 = Vector2(0,0)
	if(Input.is_action_pressed("ui_down")):
		movement.y -= 1
	if(Input.is_action_pressed("ui_up")):
		movement.y += 1
	if(Input.is_action_pressed("ui_left")):
		movement.x -= 1
	if(Input.is_action_pressed("ui_right")):
		movement.x += 1
		
	my_position += movement*delta*moveSpeed
	my_position.x = clampf(my_position.x,min_x,max_x)
	my_position.y = clampf(my_position.y,min_y,max_y)
	on_have_position.emit(my_position)
	var angle = atan2(my_position.x,1)
	cam_platform.rotation = Vector3(0,-angle,0)
	pass


func _input(event: InputEvent) -> void:
	pass
		

extends Node2D


var my_power:float

var input_disabled:bool = false

signal on_have_new_power_val(float)

func disable_inputs():
	input_disabled = true

func enable_inputs():
	input_disabled = false

func reset_aim():
	set_my_power_val(0.5)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_aim()
	pass # Replace with function body.

func set_my_power_val(val:float):
	my_power = val
	my_power = clampf(my_power,0,1)
	
	on_have_new_power_val.emit(my_power)
	

func on_input_mouse(val:Vector2):
	set_my_power_val(-val.x+0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

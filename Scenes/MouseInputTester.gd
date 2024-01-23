extends Node2D


signal on_have_position(Vector2)
@onready var goalie_control: Goalie_Control = $"../Goalie_Control"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if(event is InputEventMouseButton):
		if(event.is_pressed()):
			var global_mouse = get_viewport().get_mouse_position()
			#on_have_position.emit(global_mouse)
			goalie_control.jump_to_be_here_in(global_mouse,0.6)

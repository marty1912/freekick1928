extends Node2D

@onready var goalie_control: Goalie_Control = $"../Goalie_Control"
@export var shot_time = 0.53


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(0,2000,50):
		for y in range(0,512,50):
			var rect = ColorRect.new()
			add_child(rect)
			rect.position = Vector2(x,y)
			rect.size = Vector2(20,20)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for rect in get_children():
		if(goalie_control.can_jump_here_in_time(rect.global_position,shot_time)):
			rect.color = Color.AQUAMARINE
		else:
			rect.color = Color.RED
	pass

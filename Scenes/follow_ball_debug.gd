extends Camera3D

@onready var ball: Ball = $"../Ball"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pos = global_position
	pos.x = ball.global_position.x
	global_position = pos
	
	pass

extends Node3D

@onready var ball: Ball = $Ball

func launch_ball():
	ball.stopped = false
	var my_rotation = global_rotation
	
	ball.apply_impulse(Vector3(10,0,0))
	ball.apply_rotation(Vector3(0,0,0))
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var t:Tween = create_tween()
	t.tween_interval(1)
	t.tween_callback(launch_ball)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends Path3D

@onready var glow: Path3D = $glow

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	glow.curve.clear_points()
	for i in range(0,curve.point_count/5,1):
		glow.curve.add_point(curve.get_point_position(i))
	pass

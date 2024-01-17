extends PathFollow3D

@export var duration:float = 1
var time = 0
@export var offset:float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	progress_ratio = (time/duration) + offset
	pass

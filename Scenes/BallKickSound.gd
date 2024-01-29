extends AudioStreamPlayer


func play_with_random_pitch():
	pitch_scale = randf_range(0.5,2)
	play()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

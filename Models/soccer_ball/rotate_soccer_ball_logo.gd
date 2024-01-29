extends Node3D

@export var rotational_speed=Vector3(1,1,0)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.rotation += delta*rotational_speed
	pass

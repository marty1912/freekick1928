extends Node


var score:Vector2i = Vector2i(0,0)
var last_kick_was_goal :bool = false

signal cake()
signal do_free_kick(float)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

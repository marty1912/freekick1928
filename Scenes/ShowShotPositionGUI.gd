extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var resoultion = Vector2(256,256)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func on_set_position(position_mouse:Vector2):
	var positionOnHere = (resoultion/2 )
	var rel_pos_from_left = position_mouse
	positionOnHere += Vector2(rel_pos_from_left.x*resoultion.x,-rel_pos_from_left.y*resoultion.y)
	sprite_2d.position = positionOnHere

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

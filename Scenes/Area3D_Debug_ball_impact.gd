extends Area3D

@onready var sprite_3d: Sprite3D = $Sprite3D
var stop_ball_enabled:bool =false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if(not stop_ball_enabled):
		return
	print("body entered!")
	if(body is Ball):
		sprite_3d.global_position = body.global_position
		var ball:Ball = body as Ball
		ball.in_net = true
		print("body is ball??")
	pass # Replace with function body.

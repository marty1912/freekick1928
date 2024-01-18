extends Path3D

var follow_ball_scene = preload("res://Scenes/path_follow_ball.tscn")
@export var ball_move_duration:float = 5.0
var my_balls:Array[PathFollowBall] = []
@export var amount_of_balls :int= 30
func spawn_balls(amount:int):
	for i in range(0,amount):
		var my_offset = i as float /amount as float
		var spawned :PathFollowBall = follow_ball_scene.instantiate()
		add_child(spawned)
		spawned.offset = my_offset
		spawned.duration = ball_move_duration
		my_balls.append(spawned)
		
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_balls(amount_of_balls)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

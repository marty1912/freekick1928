extends Node


var score:Vector2i = Vector2i(0,0)
var last_kick_was_goal :bool = false

var total_kicks:int = 0
var score_x:int = 0
var score_y:int = 0


signal cake()
signal do_free_kick(float)
signal do_score_goal(int)
signal game_is_over()

func reset_all():
	total_kicks = 0
	set_my_score(Vector2i(0,0))
	last_kick_was_goal = false
	


func set_my_score(my_s:Vector2i):
	score = my_s
	score_x = score.x
	score_y = score.y
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


class_name GoalkeeperScene extends Node2D
@onready var goalie_reach_debug: Node2D = $GoalieReachDebug
var total_resolution = Vector2(2000,512)

@export var goalie_start:float = 0
@onready var goalie: Skeleton2D = $Goalie
@onready var goalie_control: Goalie_Control = $Goalie_Control
@export var goalie_reaction_time:float = 0.3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var goalie_pos_y = 316+256+512
	var goalie_pos_x = total_resolution.x*goalie_start
	goalie.position = Vector2(goalie_pos_x,goalie_pos_y)
	goalie_control.reaction_time = goalie_reaction_time
	pass # Replace with function body.

func set_jumping_position(pos:Vector2):
	goalie_control.on_jump_here(pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func ball_will_reach_at(hits_here:Vector2,in_time:float) ->bool:
	print("ball_will reach at: {x} in {y}".format({"x":hits_here,"y":in_time}))
	goalie_reach_debug.shot_time = in_time
	return goalie_control.jump_to_be_here_in(hits_here,in_time)

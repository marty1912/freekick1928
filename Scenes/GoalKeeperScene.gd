
class_name GoalkeeperScene extends Node2D

@export var goalie_start = Vector2(960,304)
@onready var goalie: Skeleton2D = $Goalie
@onready var goalie_control: Goalie_Control = $Goalie_Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	goalie.position = goalie_start
	pass # Replace with function body.

func set_jumping_position(pos:Vector2):
	goalie_control.on_jump_here(pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func ball_will_reach_at(hits_here:Vector2,in_time:float) ->bool:
	return goalie_control.jump_to_be_here_in(hits_here,in_time)

extends Node3D

@onready var goal: Area3D = $Goal
var goals_disabled : bool = false

signal on_goal_scored()

func ball_was_out():
	goals_disabled = true
	
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	goal.body_entered.connect(on_body_enter)
	pass # Replace with function body.

func on_body_enter(body:Node3D):
	if(goals_disabled):
		return
	else:
		print("goal")
		on_goal_scored.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

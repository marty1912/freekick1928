class_name GoalStuff extends Node3D
@onready var out: Area3D = $Out

@onready var goal: Area3D = $Goal
var goals_disabled : bool = false
var countdown_tween:Tween = null

signal on_goal_scored()
signal on_not_scored()

func ball_was_out():
	abort_countdown()
	goals_disabled = true
	on_not_scored.emit()
	
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	goal.body_entered.connect(on_body_enter)
	out.body_entered.connect(on_body_enter_out)
	pass # Replace with function body.



func was_preview_ball(body:Node3D):
	if((body as Ball).preview_mode):
		return true

func on_body_enter_out(body:Node3D):
	if(not body is Ball):
		return
	ball_was_out()

func abort_countdown():
	if(countdown_tween != null):
		countdown_tween.stop()
		countdown_tween = null

func ball_was_fired():
	countdown_tween= create_tween()
	countdown_tween.tween_interval(5)
	countdown_tween.tween_callback(ball_was_out)
	
func on_body_enter(body:Node3D):
	if(not body is Ball):
		return
	if(goals_disabled):
		return
	else:
		print("goal")
		abort_countdown()
		on_goal_scored.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

class_name BaseLevel extends Node3D

@onready var goal_stuff: GoalStuff = $GoalStuff

signal on_shot_taken(scored_goal:bool)
signal on_spawned_and_one_second_passed()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	goal_stuff.on_goal_scored.connect(on_goal_scored)
	goal_stuff.on_not_scored.connect(on_no_goal)
	var t:Tween = create_tween()
	t.tween_interval(1)
	t.tween_callback(func():on_spawned_and_one_second_passed.emit())
	pass # Replace with function body.


func mute_me():
	print("mute! TODO")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_goal_scored():
	var tween:Tween = create_tween()
	tween.tween_interval(2)
	tween.tween_callback(func(): on_shot_taken.emit(true))

func on_no_goal():
	var tween:Tween = create_tween()
	tween.tween_interval(2)
	tween.tween_callback(func(): on_shot_taken.emit(false))

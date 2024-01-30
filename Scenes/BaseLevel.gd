class_name BaseLevel extends Node3D

@onready var goal_stuff: GoalStuff = $GoalStuff

signal on_shot_taken(scored_goal:bool)
signal on_spawned_and_one_second_passed()

var shot_was_taken_already : bool = false

var time_elapsed:float = 0
var frames_elapsed:int = 0
var emitted_one_second=false
var goal_scored_or_not_already = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	goal_stuff.on_goal_scored.connect(on_goal_scored)
	goal_stuff.on_not_scored.connect(on_no_goal)
	#var t:Tween = create_tween()
	#t.tween_interval(1)
	#t.tween_callback(func():on_spawned_and_one_second_passed.emit())
	pass # Replace with function body.


func mute_me():
	print("mute! TODO")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(not emitted_one_second):
		time_elapsed+=delta
		frames_elapsed += 1
		if(frames_elapsed >30 and time_elapsed >1):
			emitted_one_second = true
			on_spawned_and_one_second_passed.emit()
	pass


func emit_shot_taken_if_not_already_done(val:bool):
	if(not shot_was_taken_already):
		on_shot_taken.emit(val)
		shot_was_taken_already = true

func on_goal_scored():
	if(not goal_scored_or_not_already):
		goal_scored_or_not_already = true
		var tween:Tween = create_tween()
		tween.tween_interval(4)
		tween.tween_callback(func(): emit_shot_taken_if_not_already_done(true))

func on_no_goal():
	if(not goal_scored_or_not_already):
		goal_scored_or_not_already = true
		var tween:Tween = create_tween()
		tween.tween_interval(2)
		tween.tween_callback(func(): emit_shot_taken_if_not_already_done(false))

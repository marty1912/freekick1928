extends Control

@onready var goal_animation: AnimationPlayer = $GoalAnimation
@onready var cheering: AudioStreamPlayer = $cheering
var already_scored = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_goal_scored():
	if(already_scored):
		return
	already_scored = true
	goal_animation.play("goalAnimatino")
	cheering.play()

func _on_goal_stuff_on_goal_scored() -> void:
	on_goal_scored()
	pass # Replace with function body.

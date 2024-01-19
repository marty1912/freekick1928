extends Control

@onready var goal_animation: AnimationPlayer = $GoalAnimation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_goal_scored():
	goal_animation.play("goalAnimatino")


func _on_goal_stuff_on_goal_scored() -> void:
	on_goal_scored()
	pass # Replace with function body.

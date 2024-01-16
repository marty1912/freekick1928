extends Node3D

@onready var goal: Area3D = $Goal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	goal.body_entered.connect(on_body_enter)
	pass # Replace with function body.

func on_body_enter(body:Node3D):
	print("goal")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

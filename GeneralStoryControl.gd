extends Node2D

@onready var overall_gui: OverallGUI = $OverallGUI

var dialogue_file = preload("res://dialogue/Announcer.dialogue")
@onready var grandma_animations: AnimationPlayer = $Node2D/grandmaAnimations

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueGlobals.cake.connect(on_bring_cake)
	DialogueGlobals.do_free_kick.connect(on_free_kick)
	DialogueManager.show_dialogue_balloon(dialogue_file,"intro")
	pass # Replace with function body.

func on_bring_cake():
	print("bring the cake!")
	grandma_animations.play("cake_in")

func on_free_kick(time:float):
	overall_gui.free_kick_at(time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

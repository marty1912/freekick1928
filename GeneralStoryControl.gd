extends Node2D

@onready var overall_gui: OverallGUI = $OverallGUI

var dialogue_file = preload("res://dialogue/Announcer.dialogue")
@onready var grandma_animations: AnimationPlayer = $Node2D/grandmaAnimations
@onready var overlay_init_rect: ColorRect = $OverlayInit/OverlayInit_Rect


func on_initialization_done():
	var t:Tween = create_tween()
	t.tween_property(overlay_init_rect,"modulate",Color(0,0,0,0),0.5)
	t.tween_callback(func(): DialogueManager.show_dialogue_balloon(dialogue_file,"intro"))
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueGlobals.cake.connect(on_bring_cake)
	DialogueGlobals.do_free_kick.connect(on_free_kick)
	overall_gui.on_level_load_workaround_done.connect(on_initialization_done)
	pass # Replace with function body.

func on_bring_cake():
	print("bring the cake!")
	grandma_animations.play("cake_in")

func on_free_kick(time:float):
	overall_gui.free_kick_at(time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends Node2D


@onready var overall_gui: OverallGUI = $CL_BUBBLE/OverallGUI

@onready var canvas_layer_finish: CanvasLayerFinish = $CanvasLayerFinish

var dialogue_file = preload("res://dialogue/Announcer.dialogue")
@onready var grandma_animations: AnimationPlayer = $Node2D/grandmaAnimations
@onready var overlay_init_rect: ColorRect = $OverlayInit/OverlayInit_Rect
var game_is_over:bool = false

func on_initialization_done():
	var t:Tween = create_tween()
	t.tween_property(overlay_init_rect,"modulate",Color(0,0,0,0),0.5)
	t.tween_callback(func(): DialogueManager.show_dialogue_balloon(dialogue_file,"intro"))
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueGlobals.cake.connect(on_bring_cake)
	DialogueGlobals.do_free_kick.connect(on_free_kick)
	DialogueGlobals.do_score_goal.connect(on_score_goal)
	DialogueGlobals.game_is_over.connect(on_game_over_called)
	overall_gui.on_level_load_workaround_done.connect(on_initialization_done)
	overall_gui.on_free_kick_done.connect(after_free_kick)
	DialogueManager.dialogue_ended.connect(on_dialogue_done)
	pass # Replace with function body.

func on_dialogue_done(arg):
	print("dialogue_ over")
	if(game_is_over):
		var balloon = DialogueManager.show_dialogue_balloon(dialogue_file,"outro")
		DialogueManager.dialogue_ended.disconnect(on_dialogue_done)
		DialogueManager.dialogue_ended.connect(on_final_dialogue_done)
	
	
func on_game_over_called():
	print("game over called")
	game_is_over = true
	
	
func on_final_dialogue_done(arg:DialogueResource):
	print("final dialogue_done" )
	canvas_layer_finish.on_game_ended(overall_gui.points.x,overall_gui.points.y)
	
func on_bring_cake():
	print_rich("[color=red] bring the cake!")
	grandma_animations.play("cake_in")

func on_score_goal(team:int):
	print_rich("[color=red] on score goal called")
	overall_gui.on_goal_scored(team,"DAPLAYER")
	DialogueGlobals.set_my_score(overall_gui.points)

func on_free_kick(time:float):
	print_rich("[color=red] do free kick called")
	overall_gui.free_kick_at(time)

func after_free_kick():
	print_rich("[color=red] after free kick called")
	DialogueGlobals.total_kicks += 1
	DialogueGlobals.set_my_score(overall_gui.points)
	if(not game_is_over):
		DialogueManager.show_dialogue_balloon(dialogue_file,"mid_game")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

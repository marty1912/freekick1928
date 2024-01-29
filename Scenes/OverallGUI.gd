class_name OverallGUI extends Control

const halftime :float = 45*60
const full_time:float = 90*60

var cur_time:float = 0.0
var ingame_speed:float = 90
var ticker_paused:bool = true
@export var label_score:RichTextLabel
@onready var live_ticker_list: LiveTickerList = $LiveTickerList
@export var label_time:RichTextLabel

@onready var level: Node3D = $SubViewportContainer/SubViewport/Level
@onready var dream_bubble: DreamBubble = $DreamBubbleVP/DreamBubble

@onready var cl_bubble: CanvasLayer = $".."


var points:Vector2i = Vector2i(0,0)
var currently_kicking:bool = false
@export var events_to_handle:Array[LiveTickerEvent] = []

var current_event:LiveTickerEvent = null
var free_kick_index:int = 0
var my_levels:Array[PackedScene] = [preload("res://Levels/FreeKick1.tscn"),preload("res://Levels/FreeKick2.tscn"),preload("res://Levels/FreeKick3.tscn"),preload("res://Levels/FreeKick4.tscn")]

signal on_level_load_workaround_done()
signal on_free_kick_done()

func on_goal_scored(team:int,player:String):
	if(team == 0):
		points.x += 1
	else:
		points.y +=1
	label_score.text = "[center]{x}:{y}".format({"x":points.x,"y":points.y})
	

			
func on_free_kick_goal():
	print_rich("[color=red] on kick goal")
	DialogueGlobals.last_kick_was_goal = true
	on_goal_scored(0,"DAPLAYER")
	add_liveticker_text("Amazing free kick! GOAL!!!")
	resume_after_free_kick()
	
func on_free_kick_miss():
	print_rich("[color=red] on kick miss")
	DialogueGlobals.last_kick_was_goal = false
	add_liveticker_text("And it's a miss.")
	resume_after_free_kick()
	
func resume_after_free_kick():
	dream_bubble.hide_me()
	#SoundFadeInOut.cross_fade("2DWorld","Stadium")
	SoundFadeInOut.fade_out("Stadium")
	SoundFadeInOut.fade_in("2DWorld")
	var t:Tween = create_tween()
	t.tween_interval(1.1)
	t.tween_callback(func(): cl_bubble.visible = false)
	t.tween_callback(remove_current_level)
	t.tween_callback(func(): currently_kicking = false)
	t.tween_callback(func(): on_free_kick_done.emit())
	


func on_free_kick_taken(goal:bool):
	if(goal):
		on_free_kick_goal()
	else:
		on_free_kick_miss()
		
func handle_free_kick():
	if(currently_kicking):
		print_rich("[color=red] want to do free kick but I am already kicking")
	currently_kicking = true
	ticker_paused = true
	spawn_level()
	# TODO do an effect here!
	dream_bubble.show_me()
	#SoundFadeInOut.cross_fade("Stadium","2DWorld")
	SoundFadeInOut.fade_in("Stadium")
	SoundFadeInOut.fade_to("2DWorld",-20)
	live_ticker_list.visible = false
	cl_bubble.visible = true

func remove_current_level():
	for c in level.get_children():
		c.queue_free()
	

func spawn_level():
	var level_selected:PackedScene = my_levels[free_kick_index]
	free_kick_index+= 1
	if(free_kick_index >= len(my_levels)):
		free_kick_index = 0
	var level_instance:BaseLevel = level_selected.instantiate()
	level.add_child(level_instance)
	level_instance.on_shot_taken.connect(on_free_kick_taken)
	
	return level_instance

func add_liveticker_text(to_add:String):
	var cur_minutes = floor(cur_time/60)
	var with_time = "{x}': {y}".format({"x":cur_minutes,"y":to_add})
	live_ticker_list.add_item(with_time)

func initial_spawn_done():
	remove_current_level()
	on_level_load_workaround_done.emit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var initial_load:BaseLevel = preload("res://Scenes/Pitch.tscn").instantiate()
	level.add_child(initial_load)
	initial_load.mute_me()
	initial_load.on_spawned_and_one_second_passed.connect(initial_spawn_done)
	cl_bubble.visible = false
	DialogueGlobals.reset_all()
	pass # Replace with function body.

func handle_event(evt:LiveTickerEvent):
	if(evt.is_goal):
		on_goal_scored(evt.for_team,evt.player_name)
		add_liveticker_text(evt.add_live_text)
	elif(evt.is_free_kick):
		current_event = evt
		add_liveticker_text(evt.add_live_text)
		ticker_paused = true
		var t:Tween = create_tween()
		
		t.tween_interval(1)
		t.tween_callback(handle_free_kick)
		t.play()
	else:
		add_liveticker_text(evt.add_live_text)

func updateTimeLabel():
	var minutes = floor(cur_time/60)
	var sec = cur_time as int %60
	label_time.text = "[right]%02d:%02d" % [minutes,  sec]

func check_for_events():
	for evt in events_to_handle:
		if(evt.time < cur_time and not evt.done):
			handle_event(evt)
			evt.done = true
	return

func free_kick_at(time_kick:float):
	advance_time_to(time_kick)
	handle_free_kick()

func advance_time_to(go_to_time:float):
	cur_time = go_to_time
	updateTimeLabel()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(ticker_paused):
		return
	cur_time += delta*ingame_speed
	check_for_events()
	updateTimeLabel()
	
	pass

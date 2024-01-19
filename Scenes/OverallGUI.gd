class_name OverallGUI extends Control

const halftime :float = 45*60
const full_time:float = 90*60

var cur_time:float = 0.0
var ingame_speed:float = 90
var ticker_paused:bool = false
@export var label_score:RichTextLabel
@onready var live_ticker_list: LiveTickerList = $LiveTickerList
@export var label_time:RichTextLabel
@onready var level: Node3D = $Level

var points:Vector2i = Vector2i(0,0)

@export var events_to_handle:Array[LiveTickerEvent] = []

var current_event:LiveTickerEvent = null
var free_kick_index:int = 0
var my_levels:Array[PackedScene] = [preload("res://Levels/FreeKick1.tscn"),preload("res://Levels/FreeKick2.tscn"),preload("res://Levels/FreeKick3.tscn"),preload("res://Levels/FreeKick4.tscn")]

func on_goal_scored(team:int,player:String):
	if(team == 0):
		points.x += 1
	else:
		points.y +=1
	label_score.text = "[center]{x}:{y}".format({"x":points.x,"y":points.y})

			
func on_free_kick_goal():
	on_goal_scored(0,"DAPLAYER")
	add_liveticker_text("Amazing free kick! GOAL!!!")
	resume_after_free_kick()
	
func on_free_kick_miss():
	add_liveticker_text("And it's a miss.")
	resume_after_free_kick()
	
func resume_after_free_kick():
	for c in level.get_children():
		c.queue_free()
		
	ticker_paused = false
	live_ticker_list.visible = true

func on_free_kick_taken(goal:bool):
	if(goal):
		on_free_kick_goal()
	else:
		on_free_kick_miss()
		
func handle_free_kick():
	ticker_paused = true
	var level_selected:PackedScene = my_levels[free_kick_index]
	free_kick_index+= 1
	if(free_kick_index >= len(my_levels)):
		free_kick_index = 0
	var level_instance:BaseLevel = level_selected.instantiate()
	level.add_child(level_instance)
	level_instance.on_shot_taken.connect(on_free_kick_taken)
	# TODO do an effect here!
	live_ticker_list.visible = false


func add_liveticker_text(to_add:String):
	var cur_minutes = floor(cur_time/60)
	var with_time = "{x}': {y}".format({"x":cur_minutes,"y":to_add})
	live_ticker_list.add_item(with_time)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(ticker_paused):
		return
	cur_time += delta*ingame_speed
	check_for_events()
	updateTimeLabel()
	
	pass
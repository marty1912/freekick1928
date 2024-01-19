class_name OverallGUI extends Control

const halftime :float = 45*60
const full_time:float = 90*60

var cur_time:float = 0.0
var ingame_speed:float = 90
var ticker_paused:bool = false
@export var label_score:RichTextLabel
@onready var live_ticker_list: LiveTickerList = $LiveTickerList
@export var label_time:RichTextLabel

var points:Vector2i = Vector2i(0,0)

@export var events_to_handle:Array[LiveTickerEvent] = []


func on_goal_scored(team:int,player:String):
	if(team == 0):
		points.x += 1
	else:
		points.y +=1
	label_score.text = "[center]{x}:{y}".format({"x":points.x,"y":points.y})

			
			
		

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
		print("free kick")
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

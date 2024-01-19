class_name PowerSelect extends Node2D


signal on_power_selected()
signal on_power_select_start()

var my_power:float = 0.5
	
var power_adjust_tween:Tween = null
var input_disabled:bool = false
var selected_already : bool = false
signal on_have_new_power_val(float)

func disable_inputs():
	input_disabled = true


	
func enable_inputs():
	input_disabled = false

func reset_aim():
	set_my_power_val(0.5)
	selected_already = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_aim()
	pass # Replace with function body.

func set_my_power_val(val:float):
	my_power = val
	my_power = clampf(my_power,0.0,1.0)
	
	on_have_new_power_val.emit(my_power)
	#print("set power {q} : {x}".format({"x":my_power,"q":val}))
	

func on_input_mouse(val:Vector2):
	set_my_power_val(val.x+0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	on_have_new_power_val.emit(my_power)
	pass
	
func start_power_select():
	print("start selecting power")
	power_adjust_tween = create_tween()
	my_power = 0
	power_adjust_tween.tween_method(set_my_power_val,0.0,1.0,0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	power_adjust_tween.tween_method(set_my_power_val,1.0,0.0,0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	power_adjust_tween.set_loops(-1)
	power_adjust_tween.play()
	on_power_select_start.emit()


func stop_power_adjust():
	print("stop selecting power")
	power_adjust_tween.stop()
	set_my_power_val(my_power)
	on_power_selected.emit()
	power_adjust_tween = null
	selected_already = true
	
func abort_power_adjust():
	power_adjust_tween.stop()
	set_my_power_val(my_power)
	#on_power_selected.emit()
	power_adjust_tween = null
	selected_already = false
	
func on_ball_fire_pressed():
	print("on_ball fire pressed")
	if(not selected_already and power_adjust_tween == null):
		start_power_select()
	elif(power_adjust_tween != null):
		stop_power_adjust()


func _input(event: InputEvent) -> void:
	if(event is InputEventAction):
			var action = event as InputEventAction
			if(action.is_action("ball_fire")):
				on_ball_fire_pressed()
				
		
				
	

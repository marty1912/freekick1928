extends Control
@onready var power_select: PowerSelect = $"../BallLauncher/CamPlatform/Camera3D/GUI/power_control/Sprite3D/power_select/PowerSelect"

@onready var controls_before_power: RichTextLabel = $controls_before_power
@onready var controls_power_select: RichTextLabel = $controls_power_select
var selecting_power = false
var fired=false

func on_shot_fired():
	fired = true
	var t:Tween = create_tween()
	t.tween_property(controls_before_power,"modulate",Color(1,1,1,0),0.5)
	t.tween_property(controls_power_select,"modulate",Color(1,1,1,0),0.5)
	
func on_power_select_start():
	selecting_power = true
	var t:Tween = create_tween()
	t.tween_property(controls_before_power,"modulate",Color(1,1,1,0),0.5)
	t.tween_property(controls_power_select,"modulate",Color(1,1,1,1),0.5)

func on_power_select_abort():
	selecting_power = false
	var t:Tween = create_tween()
	t.tween_property(controls_power_select,"modulate",Color(1,1,1,0),0.5)
	t.tween_property(controls_before_power,"modulate",Color(1,1,1,1),0.5)
	
func show_before_power_init():
	var t:Tween = create_tween()
	controls_power_select.modulate = Color(1,1,1,0)
	controls_before_power.modulate = Color(1,1,1,0)
	t.tween_property(controls_before_power,"modulate",Color(1,1,1,1),0.5)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_before_power_init()
	power_select.on_power_select_abort.connect(on_power_select_abort)
	power_select.on_power_select_start.connect(on_power_select_start)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if(event is InputEventMouseButton):
		if(not fired and selecting_power):
			power_select.abort_power_adjust()

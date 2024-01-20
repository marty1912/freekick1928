class_name CameraFreeKick extends Camera3D


var follow_me:Ball = null
var initial_offset:Vector3 = Vector3(0,0,0)

var distance_scale:float = 1
@onready var gui: Node3D = $GUI

func on_ball_launch(ball:Ball):
	#get_parent().remove_child(self)
	#ball.add_child(self)
	follow_me = ball
	initial_offset = self.global_position- ball.global_position
	var t:Tween = create_tween()
	t.tween_property(self,"distance_scale",6,2.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	hide_gui()
	pass
	
func hide_gui():
	var t:Tween = create_tween()
	gui.visible = false
	#t.tween_property(gui,"scale",Vector3(0,0,0),0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(follow_me != null):
		self.global_position = follow_me.global_position + initial_offset*distance_scale
	pass

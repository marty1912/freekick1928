class_name DreamBubble extends SubViewport

@onready var sprite_2d: Sprite2D = $Sprite2D

func show_me():
	var t:Tween = create_tween()
	t.tween_method(set_dissolve_val,0.0,1.0,0.5)

func hide_me():
	var t:Tween = create_tween()
	t.tween_method(set_dissolve_val,1.0,0.0,0.5)

func set_dissolve_val(value_dis:float):
	sprite_2d.material.set_shader_parameter('dissolve_value', value_dis)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_dissolve_val(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

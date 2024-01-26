class_name CanvasLayerFinish extends CanvasLayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var overlay :ColorRect 
@onready var texture_button: TextureButton = $Control/TextureButton
var restarting = false

func on_win():
	print("win")
	animation_player.play("win")

func on_defeat():
	print("defeat")
	animation_player.play("defeat")
	
func on_draw():
	print("draw")
	animation_player.play("draw")

func on_game_ended(score_x:int,score_y:int):
	print("game ended")
	self.visible= true
	if(score_x > score_y):
		on_win()
	elif(score_x == score_y):
		on_draw()
	else:
		on_defeat()
		




func restart_game():
	if(restarting):
		return
	restarting = true
	var t:Tween = create_tween()
	t.tween_property(overlay,"modulate",Color(0,0,0,1),0.5)
	t.tween_callback(func(): get_tree().change_scene_to_file(("res://overall_gui.tscn")))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false
	texture_button.pressed.connect(restart_game)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

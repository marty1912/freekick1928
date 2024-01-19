extends Node3D

signal onBallWasFired()
@onready var ball_launcher: BallLauncher = $BallLauncher

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ball_launcher.on_ball_was_fired.connect(on_fired)
	pass # Replace with function body.

func on_fired():
	onBallWasFired.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

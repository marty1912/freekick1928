class_name LiveTickerList extends VBoxContainer

var liveTickerTextScene:PackedScene = preload("res://Scenes/live_ticker_text.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_item(to_add:String):
	var item:RichTextLabel = liveTickerTextScene.instantiate()
	item.text = to_add
	add_child(item)

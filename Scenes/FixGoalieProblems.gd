extends Skeleton2D


func _ready():
	# fix from: https://github.com/godotengine/godot/issues/73168
	var mod_stack:SkeletonModificationStack2D= get_modification_stack()
	for i in range(0,mod_stack.modification_count):
		var skl_mod = mod_stack.get_modification(i)
		skl_mod.target_nodepath = skl_mod.target_nodepath
		#skl_mod.tip_nodepath = skl_mod.tip_nodepath #for SkeletonModification2DCCDIK

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

class_name Ball extends CharacterBody3D

@export var my_velocity:Vector3 = Vector3(0,0,0)
var currentRotationSpeed:Vector3 = Vector3(0,0,0)
var gravity:float = -9.8
var mass:float = 0.4

var preview_mode = false
var stopped = true
var in_goal:Area3D = null
var in_net:bool =false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var t:Tween = create_tween()
	#t.tween_interval(3)
	#t.tween_callback(func(): stopped=false)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enableCollisions():
	collision_layer = 1
	
func disableCollisions():
	collision_layer = 0
	pass

func on_goal_entered(goal:Area3D):
	in_goal = goal
	pass
	
	
func _physics_process(delta: float) -> void:
	#move_and_collide(linear_velocity)
	if(stopped):
		return
	var f_back_into_goal = Vector3(0,0,0)
	if(in_goal != null):
		if(self in in_goal.get_overlapping_bodies()):
			pass
		else:
			f_back_into_goal = (in_goal.global_position - self.global_position).normalized()*10
			in_net = true
	if(in_net):
		var drag = -my_velocity.normalized() *(my_velocity.length_squared()*1)
		f_back_into_goal += drag
	
	rotation += delta*currentRotationSpeed
	currentRotationSpeed *= (1 - 0.4*delta)
	#https://en.wikipedia.org/wiki/Bouncing_ball
	var f_gravity = gravity*mass*Vector3(0,1,0)
	var f_drag = -my_velocity.normalized() *(my_velocity.length_squared()*0.01)
	
	# magnus force: https://farside.ph.utexas.edu/teaching/329/lectures/node43.html
	var f_magnus = currentRotationSpeed.cross(my_velocity)*0.02
	#my_velocity.y += gravity * delta
	my_velocity += ((f_gravity+f_drag+f_magnus + f_back_into_goal)/mass) * delta
	var collision = move_and_collide(my_velocity*delta)
	if not collision:
		return
	else:
		if(my_velocity.length() < 1):
			my_velocity = Vector3(0.0,0.0,0.0)
			if(!stopped):
				stopped = true
				#self.freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
				self.disableCollisions()
				#onStopped.emit()
			
		var oldVel = my_velocity
		my_velocity = my_velocity.bounce(collision.get_normal()) * 0.99
		#currentRotationSpeed -= oldVel.angle_to(velocity)
		if(my_velocity.length() < 10):
			return
			#currentRotationSpeed = 0.0
		else:
			return
			#playBlobSound(velocity.length())
	pass

func apply_impulse(imp:Vector3):
	
	my_velocity = imp/mass
	#print("myvel: {x} km/h".format({"x":my_velocity.length()*3.6}))



func apply_rotation(rot:Vector3):
	self.currentRotationSpeed = rot

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	pass
	
func simulate_physics(delta:float) ->void:
	#var body_state = PhysicsServer3D.body_get_direct_state(self.get_rid())
	#var space_state : PhysicsDirectBodyState3D = get_world_3d().direct_space_state
	#_integrate_forces(body_state)
	_physics_process(delta)
	

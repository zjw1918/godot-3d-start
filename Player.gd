extends CharacterBody3D

# Emitted when the player was hit by a mob.
signal hit

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75
# Vertical impulse applied to the character upon jumping in meters per second.
@export var jump_impulse = 20
# Vertical impulse applied to the character upon bouncing over a mob in meters per second.
@export var bounce_impulse = 16

@onready var pivot: Node3D = $Pivot
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var target_velocity = Vector3.ZERO


func _physics_process(delta):
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		# Notice how we are working with the vector's x and z axes.
		# In 3D, the XZ plane is the ground plane.
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Setting the basis property will affect the rotation of the node.
		pivot.basis = Basis.looking_at(direction)
		# when move, make the animation faster
		animation_player.speed_scale = 4
	else:
		animation_player.speed_scale = 1
		
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	velocity = target_velocity
	
	# Jumping.
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	
	for i in range(get_slide_collision_count()):
		var collision := get_slide_collision(i)
		
		if collision.get_collider() == null:
			continue
		if (collision.get_collider() as Node).is_in_group("mob"):
			var mob = collision.get_collider()
			
			var dot_product := Vector3.UP.dot(collision.get_normal())
			if  dot_product > 0.75:
				print("dot_product ", dot_product)
				mob.squash()
				target_velocity.y = bounce_impulse
				break
				
	move_and_slide()
	
	# make the player arc
	pivot.rotation.x = PI / 6 * velocity.y / jump_impulse


func die():
	hit.emit()
	queue_free()


func _on_mob_detector_body_entered(body: Node3D) -> void:
	print("mob_body_entered")
	die()

extends KinematicBody2D

export var movementspeed = 600
# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	var velocity = Vector2()
	
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	
	velocity = velocity.normalized()
	velocity = move_and_slide(velocity * movementspeed)

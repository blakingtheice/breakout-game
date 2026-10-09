extends CharacterBody2D

# specify speed, need half width of box as well

const speed : float = 500.0
const half_width : float= 50.0

func _physics_process(_delta:float) -> void:
	# get direction, which is a vector that is going to left or right.
	var dir := Input.get_axis("move_left","move_right")
	# provide velocity to paddle to move it.
	velocity = Vector2(dir*speed,0)
	move_and_slide() #handles body + sliding collisions
	# clamps the position, paddle can only be between these positions
	position.x = clamp(position.x,half_width,800.0-half_width)

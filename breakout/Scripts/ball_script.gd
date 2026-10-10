extends CharacterBody2D

signal lost

const speed: float = 400.0

var launched : bool = false

func launch() -> void:
	velocity = Vector2(randf_range(-0.5,0.5),-1).normalized()*speed
	launched = true

# detect collision
func _physics_process(delta: float) -> void:
	if not launched:
		return
	
	#collision object
	var collision := move_and_collide(velocity*delta)
	
	if collision:
		var collider := collision.get_collider()
		if collider.is_in_group("paddle"):
			var half_width: float = collider.get_node("CollisionShape2D").shape.size.x / 2.0
			var offset: float = (global_position.x - collider.global_position.x) / half_width
			offset = clampf(offset,-1.0,1.0)
			velocity = Vector2(offset,-1).normalized() * speed
		else:   
			#reflects ball off whatever is hit
			velocity = velocity.bounce(collision.get_normal())
			if collider.is_in_group("bricks"):
				collider.hit()
	if global_position.y > 620:
		launched = false
		lost.emit()
	

	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

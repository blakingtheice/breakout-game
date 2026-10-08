extends StaticBody2D

signal destroyed # check for whether block should be destroyed or not


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("bricks")

func hit() -> void:
	destroyed.emit() # emit signal when hit
	queue_free() # safely deletes a node and removes from memory


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

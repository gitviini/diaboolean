extends Area2D

var is_body_entered := false
@onready var animation_sprite := $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(!is_body_entered):
		animation_sprite.play("close")
		return
	
	animation_sprite.play("open")

func _on_body_entered(body: Node2D) -> void:
	if(body.name == "player"):
		is_body_entered = true

func _on_body_exited(body: Node2D) -> void:
	if(body.name == "player"):
		is_body_entered = false

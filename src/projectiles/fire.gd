extends Area2D

@export var angle : float = 0.0
@export var target : Node2D = null
var velocity : Vector2 = Vector2.ZERO
var min_velocity := 20.0
var max_velocity := 30.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = Vector2(randf_range(min_velocity, max_velocity), 0.0)
	$Timer.start()
	$AnimatedSprite2D.play("walk")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if target:
		angle = (target.global_position - global_position).angle()
		position += velocity.rotated(angle) * delta

func _on_body_entered(body: Node2D) -> void:
	if(body.name == "player"):
		print("atingiu")
	if(body.name != "tengu"):
		queue_free()


func _on_body_exited(body: Node2D) -> void:
	if(body.name == "player"):
		print("saiu")


func _on_timer_timeout() -> void:
	print("free")
	queue_free()

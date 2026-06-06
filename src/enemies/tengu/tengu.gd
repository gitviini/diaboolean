extends CharacterBody2D

@export var SPEED = 20.0
@export var min_diference = 50
@export var projectile : PackedScene = null
var target : CharacterBody2D = null
var direction : Vector2 = Vector2.ZERO
var is_attack : bool = false
var is_cooldown : bool = false
var diference : Vector2 = Vector2.ZERO
var projectile_target : Node2D = null

func _animation() -> void:
	if is_attack:
		$AnimationPlayer.play("attack")
		return
	if velocity.length() != 0:
		if velocity.x != 0:
			$Sprite2D.flip_h = velocity.x < 0
			$FireWarpSprite2D.position.x = -33 if velocity.x < 0 else 0
			$FireWarpSprite2D.flip_h = velocity.x < 0
			$FireStartPoint.position.x = -17.0 if velocity.x < 0 else 17.0
		$AnimationPlayer.play("walk")
		return
	$AnimationPlayer.play("idle")

func _mode_walker() -> void:
	pass

func _process(delta: float) -> void:
	_animation()

func _physics_process(delta: float) -> void:
	if target: # persegue o player e em tempos atira bolas de fogo
		diference = (target.position - position)
		direction = diference.limit_length(1)
		
		if not is_cooldown and not is_attack:
			is_attack = true
			projectile_target = target
			$AttackTimer.start()
		direction = Vector2.ZERO if is_attack else direction
	else: # anda de uma lado para o outro
		direction = Vector2.ZERO
	
	velocity.normalized()
	velocity = direction * SPEED

	move_and_slide()


func _on_damage_area_body_entered(body: Node2D) -> void:
	if(body.name == "player"):
		target = body


func _on_damage_area_body_exited(body: Node2D) -> void:
	if(body.name == "player"):
		target = null

func _on_attack_timer_timeout() -> void:
	is_attack = false
	is_cooldown = true
	_instantiate_projectile()
	$Cooldown.start(3)

func _on_cooldown_timeout() -> void:
	is_cooldown = false

func _instantiate_projectile():
	var object = projectile.instantiate()
	object.global_position = $FireStartPoint.global_position
	object.target = projectile_target
	print(get_parent())
	if get_parent():
		get_parent().add_child(object)

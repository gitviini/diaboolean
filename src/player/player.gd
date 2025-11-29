extends CharacterBody2D

const SPEED = 40.0
const JUMP_VELOCITY = -400.0
@onready var animation_sprite := $AnimatedSprite2D

func animation():
	if (velocity.length() > 0):
		animation_sprite.play("walk")
		
		if (velocity.x != 0):
			animation_sprite.flip_h = velocity.x < 0
			
		return
	
	animation_sprite.play("idle")
	

func _physics_process(_delta: float) -> void:
	# -- BASIC MOVIMENT --
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
		#velocity.x = move_toward(velocity.x, 0, 500)
		#velocity.y = move_toward(velocity.y, 0, 500)
		
	animation()
	move_and_slide()

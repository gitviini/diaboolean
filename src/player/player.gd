extends CharacterBody2D

const SPEED = 40.0
@onready var animation_sprite := $AnimatedSprite2D
# --- BATTLE CONFIG ---
@export var battle_mode := false
const battle_step = 8
var can_battle_move := true;
var direction := Vector2.ZERO

func animation():
	if (velocity.length() > 0):
		animation_sprite.play("walk")
		
		if (velocity.x != 0):
			animation_sprite.flip_h = velocity.x < 0
			
		return
	
	animation_sprite.play("idle")
	

func _physics_process(_delta: float) -> void:
	# -- BASIC MOVIMENT --
	if battle_mode:
		if can_battle_move:
			velocity = Vector2.ZERO
			direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
			can_battle_move = false
			$Timer.start(0.09)
			position.x += battle_step * direction.x * 1.75
			position.y += battle_step * direction.y
	else:
		direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if direction:
			velocity = direction * SPEED
		else:
			velocity = Vector2.ZERO
		
	animation()
	move_and_slide()


func _on_timer_timeout() -> void:
	can_battle_move = true

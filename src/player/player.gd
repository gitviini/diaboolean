extends CharacterBody2D

const SPEED = 40.0
@onready var animation_player := $AnimationPlayer
@onready var logic_effect := $logic_effect
@onready var collision_logic = $collision_logic
@export var can_move := true
@export var is_on_jump := false
@export var is_on_logic_effect := false
# --- BATTLE CONFIG ---
@export var battle_mode := false
const battle_step = 8
var can_battle_move := true;
var direction := Vector2.ZERO
const colors = {
	"reset": "ffffff",
	"true": "a5d060",
	"false": "fc7790",
}
const cell_values = [
	"reset",
	"true",
	"false",
]

func animation():
	if (not is_on_jump and not is_on_logic_effect):
		collision_logic.logic_value = ""
		if(Input.is_action_pressed("ui_accept")):
			animation_player.play("jump")
		elif(velocity.length() > 0):
			animation_player.play("walk")
		else:
			animation_player.play("idle")
	if (velocity.x != 0):
		$Sprite2D.flip_h = velocity.x < 0
	
func cell_handle() -> void:
	var action_pressed = [Input.is_action_pressed("r"), Input.is_action_pressed("v"), Input.is_action_pressed("f")]
	if(true in action_pressed and not is_on_logic_effect and not is_on_jump):
		if(action_pressed[0]):
			logic_effect.modulate = colors["reset"]
			collision_logic.logic_value = "reset"
		elif(action_pressed[1]):
			logic_effect.modulate = colors["true"]
			collision_logic.logic_value = "true"
		elif(action_pressed[2]):
			logic_effect.modulate = colors["false"]
			collision_logic.logic_value = "false"
		
		animation_player.play("logic")

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
		if direction and can_move:
			velocity = direction * SPEED
			if(is_on_jump):
				velocity *= 1.5
		else:
			velocity = Vector2.ZERO
	animation()
	cell_handle()
	move_and_slide()

func _on_timer_timeout() -> void:
	can_battle_move = true

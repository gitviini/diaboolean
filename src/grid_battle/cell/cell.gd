extends RigidBody2D

signal setted_logic_value(_name: String)
@export var logic_operator : String = ""
@onready var sprite := $Sprite2D
@export var logic_value = "reset"
@export var around_logic_values : Array[RigidBody2D] = []
const logic_operator_simbols = {
	"condition":0,
	"negation":1
}
const background_colors = {
	"reset": "ffffff00",
	"focus": "7b00ff20",
	"focus_logic": "7b00ff00",
}
const logic_colors = {
	"reset": "ffffff",
	"true": "a5d060",
	"false": "fc7790",
}
@onready var entered_body : CharacterBody2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(logic_operator in logic_operator_simbols.keys()):
		$AnimationPlayer.play("simbol")
		z_index = 1
		$logic_simbol.frame = logic_operator_simbols.get(logic_operator)
		for around_logic in around_logic_values:
			around_logic.setted_logic_value.connect(call_logic_handle)
		return
	z_index = 0
	$AnimationPlayer.play("value")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_cell_area_entered(area: Area2D) -> void:
	if(area.name == "collision_logic" and area.get("logic_value") and not $logic_simbol.visible):
		logic_value = area.logic_value
		sprite.modulate = logic_colors.get(logic_value)
		$ColorRect.color = background_colors["focus" if logic_value == "reset" else "focus_logic"]
		setted_logic_value.emit(name)

func _on_cell_body_entered(body: Node2D) -> void:
	if(body.name == "player" and not $logic_simbol.visible):
		$ColorRect.color = background_colors["focus" if logic_value == "reset" else "focus_logic"]

func _on_cell_body_exited(body: Node2D) -> void:
	if(body.name == "player" and not $logic_simbol.visible):
		$ColorRect.color = background_colors["reset"]

# --- LOGIC HANDLERS ---
func set_logic_value() -> void:
	sprite.modulate = logic_colors.get(logic_value)
	$ColorRect.color = background_colors["focus" if logic_value == "reset" else "focus_logic"]

func call_logic_handle(_name: String) -> void:
	if(not $logic_simbol.visible):
		return
	
	match (logic_operator):
		"negation":
			negation_handle(_name)

func negation_handle(_name: String) -> void:
	var left = around_logic_values[0]
	var right = around_logic_values[1]
	
	if(_name == "left" and left.logic_value != "reset"):
		right.set("logic_value", "true" if left.logic_value == "false" else "false")
	if(_name == "right" and right.logic_value != "reset"):
		left.set("logic_value", "true" if right.logic_value == "false" else "false")
	
	left.set_logic_value()
	right.set_logic_value()

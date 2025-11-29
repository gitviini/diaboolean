extends Area2D

@export var text : String
@onready var dialog_box := $dialog_box
@onready var dialog_label := $dialog_box/Label
@onready var typing_timer := $Timer
var can_typing := false
var is_body_entered := false
var index := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if(!is_body_entered):
		dialog_box.visible = false
		return
	
	dialog_box.visible = true
	var text_len = len(text)-len(dialog_label.text)
	
	if(can_typing and text_len > 0):
		# -- TYPING EFFECT --
		dialog_label.text = text.left(index)
		can_typing = false
		index += 1
		typing_timer.start()


func _on_body_entered(body: Node2D) -> void:
	if(body.name == "player"):
		# -- IF PLAYER ENTERED --
		# reset text and show box
		dialog_label.text = ""
		is_body_entered = true
		index = 0
		typing_timer.start()


func _on_body_exited(body: Node2D) -> void:
	if(body.name == "player"):
		# -- IF PLAYER EXITED --
		# hidden box
		is_body_entered = false


func _on_timer_timeout() -> void:
	can_typing = true

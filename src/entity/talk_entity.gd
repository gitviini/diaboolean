extends CharacterBody2D

@export var text : String
@onready var dialog_box := $dialog_box
@onready var dialog_label := $dialog_box/Label
@onready var typing_timer := $Timer
@export var sprite_resource := Resource
@onready var sprite := $Sprite2D
@export var vframes := 0
@export var hframes := 0
var can_typing := false
var is_body_entered := false
var index := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set provider texture
	sprite.texture = sprite_resource
	sprite.vframes = vframes
	sprite.hframes = hframes

func animation() -> void:
	$Timer_Animation.start(0.5)
	if(sprite.frame < hframes - 1):
		sprite.frame+=1
		return
	sprite.frame = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if(!is_body_entered):
		dialog_box.visible = false
		return
	
	dialog_box.visible = true
	var text_len = len(text)-len(dialog_label.text)
	
	if(can_typing and text_len > 0):
		# -- TYPING EFFECT --
		dialog_label.text = text.left(index) + "|"
		can_typing = false
		index += 1
		typing_timer.start()
	elif(text_len == 0):
		# remove line
		dialog_label.text = text

func _on_timer_timeout() -> void:
	can_typing = true


func _on_timer_animation_timeout() -> void:
	animation()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(body.name == "player"):
		# -- IF PLAYER ENTERED --
		# reset text and show box
		dialog_label.text = "|"
		is_body_entered = true
		index = 0
		typing_timer.start()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if(body.name == "player"):
		# -- IF PLAYER EXITED --
		# hidden box
		is_body_entered = false

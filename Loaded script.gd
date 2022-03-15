extends Node
var opening_played = false
var title_screen = true
var yeti_attack = false
var yetis_dead = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func change_title_screen():
	title_screen = false
	
func change_opening_played():
	opening_played = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

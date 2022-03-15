extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	if body.is_in_group("yetis"):
		$CPUParticles.emitting = true
		$AudioStreamPlayer.playing = true
		$Timer.start()



func _on_Timer_timeout():
	get_tree().call_group("game", "lose_game")
	queue_free()

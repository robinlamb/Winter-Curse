extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var arrow = preload("res://modelscenes/arrow.tscn")
var arrow_instance

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func aim():
	arrow_instance = arrow.instance()
	add_child(arrow_instance)
	arrow_instance.transform = $Position3D.global_transform
	
func shoot():
	$AnimationPlayer.play("shoot (copy)")
	$Timer.start()
	


func _on_Timer_timeout():
	arrow_instance.velocity = -arrow_instance.transform.basis.z * arrow_instance.arrow_velocity
	arrow_instance.shoot = true

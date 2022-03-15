extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var dialog = Dialogic.start('tlAncestorBow')
	add_child(dialog)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if (arrow_shoot):
#		$arrow.transform.basis.z(Vector3(0, 1, 3))


func _on_Timer_timeout():
	$hoodedman.shoot_bow()
	$ArrowFly.start()


func _on_ArrowFly_timeout():
	$hoodedman.shoot_arrow = true
	$hoodedman/Armature/Skeleton/BoneAttachment/bow/arrow.shoot = true

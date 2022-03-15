extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var shoot_arrow = false
var velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shoot_arrow:
		velocity = ((Vector3.FORWARD * 50) * delta ) 
		$Armature/Skeleton/BoneAttachment/bow/arrow.look_at(transform.origin + velocity.normalized(), Vector3.UP)
		$Armature/Skeleton/BoneAttachment/bow/arrow.transform.origin += velocity
func shoot_bow():
	$AnimationPlayer.play("shoot  2")
	$Armature/Skeleton/BoneAttachment/bow/AnimationPlayer.play("shoot (copy)")

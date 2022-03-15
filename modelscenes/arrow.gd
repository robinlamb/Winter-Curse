extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var arrow_velocity = 25
export var gravity = 2

var velocity = Vector3.ZERO

var shoot = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if shoot:
		transform.origin.y -= gravity
	else:
		move_and_slide(velocity)


func _on_Area_body_entered(body):
	if body.is_in_group("yetis"):
		body.set_state_dead()


func _on_Area_area_entered(area):
		if area.is_in_group("yetis"):
			area.get_parent().set_state_dead()

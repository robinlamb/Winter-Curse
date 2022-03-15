extends KinematicBody

export var max_speed = 17
export var gravity = 30
var can_move = true
var arrow = preload("res://modelscenes/arrow.tscn")
var shooting = false

var velocity = Vector3.ZERO

onready var pivot = $Pivot

func _ready():
	$AnimationPlayer.play("idle2")

func _physics_process(delta):
	var input_vector = get_input_vector()
	if can_move:
		apply_movement(input_vector)
	
	
	if LoadedScript.yeti_attack and can_move:
		if Input.is_action_just_pressed("shoot"):
			can_move = false
			shooting = true
			$Pivot/Armature/Skeleton/BoneAttachment/bow.visible = true
			$AnimationPlayer.play("shoot")
			$Timer.start()
			var arrowinstance = arrow.instance()
			$Spatial.add_child(arrowinstance)
			arrowinstance.look_at(transform.origin + velocity.normalized(), Vector3.UP)
			arrowinstance.velocity = get_arrow_velocity()
	
	apply_gravity(delta)
	if !can_move:
		velocity.x = 0
		velocity.z = 0
		
	if !shooting:
		velocity = move_and_slide(velocity, Vector3.UP)

	
	
func get_input_vector():
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return input_vector.normalized()
	
func get_arrow_velocity():
	var arrow_velocity = Vector3()
	if (pivot.get_rotation_degrees().y < -150):
		arrow_velocity = Vector3.FORWARD
	if pivot.get_rotation_degrees().y >=-150 and pivot.get_rotation_degrees().y < -50:
		arrow_velocity = Vector3.LEFT
	if pivot.get_rotation_degrees().y >=-50 and pivot.get_rotation_degrees().y < 50:
		arrow_velocity = Vector3.BACK
	if pivot.get_rotation_degrees().y > 50:
		arrow_velocity = Vector3.RIGHT
	arrow_velocity = arrow_velocity * 50
	return arrow_velocity
	

func apply_movement(input_vector):
	velocity.x = input_vector.x * max_speed
	velocity.z = input_vector.z * max_speed
	
	if input_vector.x != 0 or input_vector.z != 0:
		input_vector.y = $Pivot/Armature/Skeleton/Cube001.transform.origin.y + 1
		pivot.look_at(translation - input_vector, Vector3.UP)
		print(pivot.get_rotation_degrees())
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("idle2")
	
func set_can_move(bl_can_move):
	can_move = bl_can_move
	
func apply_gravity(delta):
	velocity.y -= gravity * delta
	#pass


func _on_Timer_timeout():
	$Timer.stop()
	$Timer.set_wait_time(1.0)
	can_move = true
	shooting = false
	$Pivot/Armature/Skeleton/BoneAttachment/bow.visible = false
	

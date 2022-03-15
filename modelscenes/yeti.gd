extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var state
var speed = 5
export var attack_target_location = Vector3()
var path = []
var cur_path_idx = 0
var threshold = .1
var velocity = Vector3.ZERO
onready var nav = get_parent()
onready var look_direction = $LookDirection
const death_sound = preload("res://sounds/yetihit.ogg")

enum {
	IDLE,
	MARCH_CUTSCENE,
	DYING_CURSE_CUTSCENE,
	ATTACK,
	SMASH_HOUSE,
	DEAD,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	state = IDLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		MARCH_CUTSCENE:
			move_and_slide(Vector3(-speed, 0, 0), Vector3.UP)
		ATTACK:
			if path.size() > 0:
				move_to_target(attack_target_location)
		
func set_state_march_cutscene():
	state = MARCH_CUTSCENE
	$AnimationPlayer.play("walk (copy)")
	$AudioStreamPlayer3D.playing = true
	
func set_state_death_cutscene():
	$AnimationPlayer.play("curse2")

func set_state_attack():
	$AudioStreamPlayer3D.playing = true
	state = ATTACK
	$AnimationPlayer.play("walk (copy)")
	get_target_path(attack_target_location)

func set_state_dead():
	state = DEAD
	$AnimationPlayer.play("die001")
	$AudioStreamPlayer3D.stream = death_sound
	$AudioStreamPlayer3D.playing = true
	$Timer.start()
	get_tree().call_group("game", "yeti_death_count_up")

func move_to_target(target_pos):
	look_direction.look_at(target_pos, Vector3.UP)
	rotate_y(deg2rad(look_direction.rotation.y * speed))
	if global_transform.origin.distance_to(path[cur_path_idx]) < threshold:
		path.remove(0)
	else:
		var direction = path[cur_path_idx] - global_transform.origin
		velocity = direction.normalized() * speed
		move_and_slide(velocity, Vector3.UP)
		
func get_target_path(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)


func _on_Timer_timeout():
	queue_free()

func become_visible():
	self.visible = true

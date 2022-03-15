extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var active = false
var text_played = false
var running = false
var fallen = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$SpeechBubble.visible = active
	if running:
		move_and_slide(Vector3(5,0,0), Vector3.UP)
	

func _input(event):
	if get_node_or_null('DialogNode') == null:
		if event.is_action_pressed("ui_accept") and active and !text_played:
			get_tree().paused = true
			var dialog = Dialogic.start('tlJack')
			dialog.pause_mode = Node.PAUSE_MODE_PROCESS
			dialog.connect("dialogic_signal", self, "dialog_listener")
			dialog.connect('timeline_end', self, 'unpause')
			add_child(dialog)

func dialog_listener(string):
	match string:
		"key":
			get_tree().call_group("game", "got_key")
			
func _on_TalkArea_body_entered(body):
	if body.name == "winterhero" and !running and !fallen:
		active = true

func unpause(timeline_name):
	get_tree().paused = false
	text_played = true
	active = false

func _on_TalkArea_body_exited(body):
	if body.name == "winterhero" and !running and !fallen:
		active = false
		text_played = false



func _on_AnimationPlayer_animation_finished(animname):
	if animname == "fall":
		$AnimationPlayer.play("onground (copy)")
		

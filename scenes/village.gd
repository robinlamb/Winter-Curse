extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var imgCookie = preload("res://images/cookie.png")
var imgCarrot = preload("res://images/carrot.png")
var imgKey = preload("res://images/key.png")
var imgBow = preload("res://images/bow.png")
var dead_yetis = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if LoadedScript.title_screen:
		$winterhero.can_move = false
	if !LoadedScript.title_screen:
		$lblTitle.visible = false
		$btnPlay.visible = false
	if !LoadedScript.opening_played and !LoadedScript.title_screen:
		$winterhero.can_move = false
		var dialog = Dialogic.start('tlOpening')
		dialog.pause_mode = Node.PAUSE_MODE_PROCESS
		add_child(dialog)
		LoadedScript.opening_played = true
	else:
		$winterhero.can_move = true
	if LoadedScript.yeti_attack:
		dissapearPeopleAddYetis()
		$Letter.visible = false
	if LoadedScript.yetis_dead:
		$winterhero.can_move = false
		var dialog = Dialogic.start('tlGameWon')
		dialog.connect("dialogic_signal", self, "dialog_listener")
		add_child(dialog)
	

func got_letter():
	$AudioGetItem.playing = true
	$CurrentItem.visible = true
	
func got_carrot():
	$AudioGetItem.playing = true
	$CurrentItem.set_texture(imgCarrot)
	
func got_cookies():
	$AudioGetItem.playing = true
	$snowman/carrot.visible = true
	$CurrentItem.set_texture(imgCookie)
	
func got_key():
	$AudioGetItem.playing = true
	$CurrentItem.set_texture(imgKey)
	
func got_bow():
	$AudioGetItem.playing = true
	$CurrentItem.set_texture(imgBow)
	$winterhero.can_move = false
	$winterman1.transform.origin = (Vector3(.406,-1.254,3.886))
	$winterman1.set_rotation_degrees(Vector3(0, 90, 0))
	$winterman1/AnimationPlayer.play("run (copy)")
	$winterman1.running = true
	$tmrJackRunning.start()


func _on_tmrJackRunning_timeout():
	$tmrJackRunning.stop()
	$tmrJackRunning.set_wait_time(2.0)
	$winterman1.running = false
	$winterman1.fallen = true
	$winterman1/AnimationPlayer.play("fall")
	var text_played = false
	if !text_played:
		text_played = true
		var dialog = Dialogic.start('tlYetisComing')
		dialog.connect("dialogic_signal", self, "dialog_listener")
		add_child(dialog)

func dialog_listener(string):
	match string:
		"yetis":
			switchscenes()
		"end":
			$lblGameOver.text = "The End"
			$lblGameOver.visible = true
	
func switchscenes():
	print("function called")
	$tmrSwitchScenes.start()
	LoadedScript.yeti_attack = true

func lose_game():
	$winterhero.can_move = false
	$btnTryAgain.visible = true
	$lblGameOver.visible = true
	

func _on_tmrSwitchScenes_timeout():
	$tmrSwitchScenes.stop()
	$tmrSwitchScenes.set_wait_time(2.0)
	$ColorRect.visible = true
	$ColorRect/AnimationPlayer.play("screenfade")
	$tmrDissapearPeopleAddYetis.start()


func _on_AnimationPlayer_animation_finished(anim_name):
	$ColorRect.visible = false


func _on_tmrDissapearPeopleAddYetis_timeout():
	$tmrDissapearPeopleAddYetis.stop()
	$tmrDissapearPeopleAddYetis.set_wait_time(2.0)
	dissapearPeopleAddYetis()


func dissapearPeopleAddYetis():
	$winterman1.visible = false
	$girl1.visible = false
	$woman1.visible = false
	$winteroldman.visible = false
	$winterhero.can_move = true
	get_tree().call_group("yetis", "become_visible")
	get_tree().call_group("yetis", "set_state_attack")


func _on_btnTryAgain_pressed():
	get_tree().reload_current_scene()


func _on_btnPlay_pressed():
	LoadedScript.title_screen = false
	get_tree().reload_current_scene()
	
func yeti_death_count_up():
	dead_yetis += 1
	if dead_yetis == 4:
		LoadedScript.yetis_dead = true
		LoadedScript.yeti_attack = false
		get_tree().reload_current_scene()
